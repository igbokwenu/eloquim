// eloquim_server/lib/src/endpoints/conversation_endpoint.dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ConversationEndpoint extends Endpoint {
  
  /// Get all conversations for current user
  Future<List<Conversation>> getConversations(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    // Find all conversations where user is a participant
    final conversations = await Conversation.db.find(
      session,
      where: (t) => t.participantIds.containsJson(authInfo.userId),
      orderBy: (t) => t.lastMessageAt,
      orderDescending: true,
    );

    return conversations;
  }

  /// Create a new conversation
  Future<Conversation> createConversation(
    Session session,
    List<int> participantIds,
    String? title,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    // Ensure current user is in participants
    if (!participantIds.contains(authInfo.userId)) {
      participantIds.add(authInfo.userId);
    }

    final conversation = Conversation(
      type: participantIds.length == 2 ? 'p2p' : 'group',
      title: title,
      participantIds: participantIds,
      startedAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
      status: 'active',
    );

    final savedConversation = await Conversation.db.insertRow(session, conversation);
    
    // Notify all participants
    for (final participantId in participantIds) {
      await session.messages.postMessage(
        'user_$participantId',
        {'type': 'new_conversation', 'conversation': savedConversation},
      );
    }

    return savedConversation;
  }

  /// Get conversation details
  Future<Conversation?> getConversation(Session session, int conversationId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final conversation = await Conversation.db.findById(session, conversationId);
    
    if (conversation != null && 
        !conversation.participantIds.contains(authInfo.userId)) {
      throw Exception('Not a participant in this conversation');
    }

    return conversation;
  }

  /// Archive a conversation
  Future<void> archiveConversation(Session session, int conversationId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final conversation = await Conversation.db.findById(session, conversationId);
    if (conversation != null && 
        conversation.participantIds.contains(authInfo.userId)) {
      conversation.status = 'archived';
      await Conversation.db.updateRow(session, conversation);
    }
  }

  /// Delete a conversation
  Future<void> deleteConversation(Session session, int conversationId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final conversation = await Conversation.db.findById(session, conversationId);
    if (conversation != null && 
        conversation.participantIds.contains(authInfo.userId)) {
      // In a real app, you might want soft delete or remove user from participants
      await Conversation.db.deleteRow(session, conversation);
      
      // Also delete all messages
      final messages = await Message.db.find(
        session,
        where: (t) => t.conversationId.equals(conversationId),
      );
      for (final message in messages) {
        await Message.db.deleteRow(session, message);
      }
    }
  }
}