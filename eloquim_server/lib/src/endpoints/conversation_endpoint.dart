import 'package:serverpod/serverpod.dart' hide Message;
import 'package:serverpod_auth_idp_server/core.dart';
import '../generated/protocol.dart';

class ConversationEndpoint extends Endpoint {
  /// Get all conversations for current user
  Future<List<Conversation>> getConversations(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.authUserId),
    );
    if (user == null) throw Exception('User record not found');
    final userId = user.id!;

    // FIX: Serverpod ORM doesn't support 'contains' on JSON arrays easily yet.
    // Filter in Dart for V1. For V2/Scale, use a relational table "ConversationParticipant".
    final allConversations = await Conversation.db.find(
      session,
      orderBy: (t) => t.lastMessageAt,
      orderDescending: true,
    );

    return allConversations
        .where((c) => c.participantIds.contains(userId))
        .toList();
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

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.authUserId),
    );
    if (user == null) throw Exception('User record not found');
    final userId = user.id!;

    if (!participantIds.contains(userId)) {
      participantIds.add(userId);
    }

    String? effectiveTitle = title;
    if (effectiveTitle == null && participantIds.length == 2) {
      final otherId = participantIds.firstWhere((id) => id != userId);
      final otherUser = await User.db.findById(session, otherId);
      if (otherUser != null) {
        effectiveTitle = otherUser.username;
      }
    }

    final conversation = Conversation(
      type: participantIds.length == 2 ? 'p2p' : 'group',
      title: effectiveTitle ?? 'Conversation',
      participantIds: participantIds,
      startedAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
      status: 'active',
    );

    final savedConversation = await Conversation.db.insertRow(
      session,
      conversation,
    );

    // Notify all participants
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
  Future<Conversation?> getConversation(
    Session session,
    int conversationId,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.authUserId),
    );
    if (user == null) throw Exception('User record not found');
    final userId = user.id!;

    final conversation = await Conversation.db.findById(
      session,
      conversationId,
    );

    if (conversation != null && !conversation.participantIds.contains(userId)) {
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

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.authUserId),
    );
    if (user == null) throw Exception('User record not found');
    final userId = user.id!;

    final conversation = await Conversation.db.findById(
      session,
      conversationId,
    );
    if (conversation != null && conversation.participantIds.contains(userId)) {
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

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.authUserId),
    );
    if (user == null) throw Exception('User record not found');
    final userId = user.id!;

    final conversation = await Conversation.db.findById(
      session,
      conversationId,
    );
    if (conversation != null && conversation.participantIds.contains(userId)) {
      await Conversation.db.deleteRow(session, conversation);

      // Also delete all messages
      await Message.db.deleteWhere(
        session,
        where: (t) => t.conversationId.equals(conversationId),
      );
    }
  }
}
