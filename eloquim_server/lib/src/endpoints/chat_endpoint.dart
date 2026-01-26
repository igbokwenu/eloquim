// eloquim_server/lib/src/endpoints/chat_endpoint.dart
import 'package:serverpod/serverpod.dart'
    hide Message; // FIX: Hide Serverpod's internal Message class
import 'package:serverpod_auth_idp_server/core.dart';
import '../generated/protocol.dart';
import '../services/ai_translation_service.dart';

class ChatEndpoint extends Endpoint {
  /// Send a message with emoji translation
  Future<Message> sendMessage(
    Session session,
    SendMessageRequest request,
  ) async {
    // 1. Authenticate
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    // FIX: Parse userId from string (Serverpod Auth standard)
    // Get custom user object to get the int ID
    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.authUserId),
    );
    if (user == null) {
      throw Exception('User record not found');
    }
    final userId = user.id!;

    try {
      // 2. Get conversation context
      final contextMessages = await Message.db.find(
        session,
        where: (t) => t.conversationId.equals(request.conversationId),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
        limit: 6,
      );

      // 3. Call AI translation service (if not already translated by client)
      String translatedText = request.translatedText ?? '';
      double confidenceScore = request.confidenceScore ?? 0.0;

      if (translatedText.isEmpty) {
        final aiService = AITranslationService(session);
        final translation = await aiService.translateEmojis(
          emojiSequence: request.emojiSequence,
          tone: request.tone,
          personaId: request.personaId,
          conversationContext: contextMessages.reversed.toList(),
        );
        translatedText = translation.text;
        confidenceScore = translation.confidence;
      }

      // 4. Create message
      final message = Message(
        conversationId: request.conversationId,
        senderId: userId,
        emojiSequence: request.emojiSequence,
        rawIntent: request.rawIntent,
        translatedText: translatedText,
        tone: request.tone,
        personaUsed: request.personaId,
        confidenceScore: confidenceScore,
        mediaGifUrl: request.mediaGifUrl,
        replyToMsgId: request.replyToMsgId,
        recommendedEmojis: request.recommendedEmojis,
        createdAt: DateTime.now(),
      );

      // 5. Persist to database
      final savedMessage = await Message.db.insertRow(session, message);

      // 6. Broadcast to conversation participants via WebSocket
      await session.messages.postMessage(
        'chat_${request.conversationId}',
        savedMessage,
      );

      // 7. Update conversation timestamp
      await _updateConversationTimestamp(session, request.conversationId);

      return savedMessage;
    } catch (e) {
      session.log('Error sending message: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Stream messages for real-time chat
  Stream<Message> streamChat(Session session, int conversationId) async* {
    await _verifyParticipant(session, conversationId);

    final stream = session.messages.createStream<Message>(
      'chat_$conversationId',
    );

    await for (final message in stream) {
      yield message;
    }
  }

  /// Get recent messages
  Future<List<Message>> getMessages(
    Session session,
    int conversationId, {
    int limit = 50,
    DateTime? before,
  }) async {
    await _verifyParticipant(session, conversationId);

    var query = Message.db.find(
      session,
      where: (t) => t.conversationId.equals(conversationId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: limit,
    );

    final messages = await query;
    return messages.reversed.toList();
  }

  /// Mark messages as read
  Future<void> markAsRead(
    Session session,
    int conversationId,
    int messageId,
  ) async {
    await _verifyParticipant(session, conversationId);

    final message = await Message.db.findById(session, messageId);
    if (message != null) {
      // Use copyWith for updates
      final updatedMessage = message.copyWith(readAt: DateTime.now());
      await Message.db.updateRow(session, updatedMessage);
    }
  }

  /// Helper: Verify user is participant
  Future<void> _verifyParticipant(
    Session session,
    int conversationId,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    // Get custom user object to get the int ID
    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.authUserId),
    );
    if (user == null) {
      throw Exception('User record not found');
    }
    final userId = user.id!;

    final conversation = await Conversation.db.findById(
      session,
      conversationId,
    );
    if (conversation == null) {
      throw Exception('Conversation not found');
    }

    if (!conversation.participantIds.contains(userId)) {
      throw Exception('Not a participant in this conversation');
    }
  }

  /// Helper: Update conversation timestamp
  Future<void> _updateConversationTimestamp(
    Session session,
    int conversationId,
  ) async {
    final conversation = await Conversation.db.findById(
      session,
      conversationId,
    );
    if (conversation != null) {
      final updated = conversation.copyWith(lastMessageAt: DateTime.now());
      await Conversation.db.updateRow(session, updated);
    }
  }
}
