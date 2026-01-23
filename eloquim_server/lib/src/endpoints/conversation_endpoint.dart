// eloquim_server/lib/src/endpoints/conversation_endpoint.dart
import 'package:serverpod/serverpod.dart'hide Message;
import '../generated/protocol.dart';

class ConversationEndpoint extends Endpoint {
  
  /// Get all conversations for current user
  Future<List<Conversation>> getConversations(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    final userId = int.parse(authInfo.userIdentifier);

    // FIX: Serverpod ORM doesn't support 'contains' on JSON arrays easily yet.
    // Filter in Dart for V1. For V2/Scale, use a relational table "ConversationParticipant".
    final allConversations = await Conversation.db.find(
      session,
      orderBy: (t) => t.lastMessageAt,
      orderDescending: true,
    );

    return allConversations.where((c) => c.participantIds.contains(userId)).toList();
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
    final userId = int.parse(authInfo.userIdentifier);

    if (!participantIds.contains(userId)) {
      participantIds.add(userId);
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
    // FIX: Use SystemNotification object instead of Map
    final notification = SystemNotification(
      type: 'new_conversation',
      conversation: savedConversation,
    );

    for (final participantId in participantIds) {
      await session.messages.postMessage(
        'user_$participantId',
        notification,
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
    final userId = int.parse(authInfo.userIdentifier);

    final conversation = await Conversation.db.findById(session, conversationId);
    
    if (conversation != null && 
        !conversation.participantIds.contains(userId)) {
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
    final userId = int.parse(authInfo.userIdentifier);

    final conversation = await Conversation.db.findById(session, conversationId);
    if (conversation != null && 
        conversation.participantIds.contains(userId)) {
      
      final updated = conversation.copyWith(status: 'archived');
      await Conversation.db.updateRow(session, updated);
    }
  }

  /// Delete a conversation
  Future<void> deleteConversation(Session session, int conversationId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    final userId = int.parse(authInfo.userIdentifier);

    final conversation = await Conversation.db.findById(session, conversationId);
    if (conversation != null && 
        conversation.participantIds.contains(userId)) {
      
      await Conversation.db.deleteRow(session, conversation);
      
      // Also delete all messages
      await Message.db.deleteWhere(
        session,
        where: (t) => t.conversationId.equals(conversationId),
      );
    }
  }
}