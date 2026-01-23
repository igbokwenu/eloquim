// eloquim_server/lib/src/endpoints/recommendation_endpoint.dart
import 'package:serverpod/serverpod.dart' hide Message; // FIX: Hide Message
import '../generated/protocol.dart';
import '../services/ai_translation_service.dart';

class RecommendationEndpoint extends Endpoint {
  Future<RecommendationResponse> getRecommendations(
    Session session,
    int conversationId,
    String partialText,
    String tone,
    String personaId,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');

    try {
      final contextMessages = await Message.db.find(
        session,
        where: (t) => t.conversationId.equals(conversationId),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
        limit: 6,
      );

      final aiService = AITranslationService(session);
      return await aiService.recommendEmojis(
        partialText: partialText,
        tone: tone,
        personaId: personaId,
        conversationContext: contextMessages.reversed.toList(),
      );
    } catch (e) {
      session.log('Error: $e', level: LogLevel.error);

      // Fallback
      return RecommendationResponse(
        singles: ['😊', '👍', '💯', '🔥', '✨', '😂'],
        combos: [
          EmojiCombo(emojis: ['👋', '😊'], meaning: 'Friendly greeting'),
          EmojiCombo(emojis: ['🤔', '💭'], meaning: 'Thinking'),
          EmojiCombo(emojis: ['💯', '🔥'], meaning: 'Absolutely fire!'),
        ],
      );
    }
  }
}
