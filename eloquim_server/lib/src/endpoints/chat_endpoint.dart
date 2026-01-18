// eloquim_server/lib/src/endpoints/chat_endpoint.dart
import 'package:serverpod/serverpod.dart';
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
    final userId = authInfo.userId;

    try {
      // 2. Get conversation context (last 6 messages)
      final contextMessages = await Message.db.find(
        session,
        where: (t) => t.conversationId.equals(request.conversationId),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
        limit: 6,
      );

      // 3. Call AI translation service
      final aiService = AITranslationService(session);
      final translation = await aiService.translateEmojis(
        emojiSequence: request.emojiSequence,
        tone: request.tone,
        personaId: request.personaId,
        conversationContext: contextMessages.reversed.toList(),
      );

      // 4. Create message
      final message = Message(
        conversationId: request.conversationId,
        senderId: userId,
        emojiSequence: request.emojiSequence,
        rawIntent: request.rawIntent,
        translatedText: translation.text,
        tone: request.tone,
        personaUsed: request.personaId,
        confidenceScore: translation.confidence,
        mediaGifUrl: request.mediaGifUrl,
        replyToMsgId: request.replyToMsgId,
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
    // Verify user is participant
    await _verifyParticipant(session, conversationId);

    // Create WebSocket stream
    final stream = session.messages.createStream<Message>(
      'chat_$conversationId',
    );

    await for (final message in stream) {
      yield message;
    }
  }

  /// Get recent messages (for initial load)
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
      message.readAt = DateTime.now();
      await Message.db.updateRow(session, message);
    }
  }

  /// Helper: Verify user is participant in conversation
  Future<void> _verifyParticipant(
    Session session,
    int conversationId,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final conversation = await Conversation.db.findById(session, conversationId);
    if (conversation == null) {
      throw Exception('Conversation not found');
    }

    if (!conversation.participantIds.contains(authInfo.userId)) {
      throw Exception('Not a participant in this conversation');
    }
  }

  /// Helper: Update conversation last message timestamp
  Future<void> _updateConversationTimestamp(
    Session session,
    int conversationId,
  ) async {
    final conversation = await Conversation.db.findById(session, conversationId);
    if (conversation != null) {
      conversation.lastMessageAt = DateTime.now();
      await Conversation.db.updateRow(session, conversation);
    }
  }
}