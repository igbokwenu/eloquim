// eloquim_server/lib/src/endpoints/recommendation_endpoint.dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/ai_translation_service.dart';

class RecommendationEndpoint extends Endpoint {
  
  /// Get emoji recommendations based on context
  Future<RecommendationResponse> getRecommendations(
    Session session,
    int conversationId,
    String partialText,
    String tone,
    String personaId,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    try {
      // Get conversation context
      final contextMessages = await Message.db.find(
        session,
        where: (t) => t.conversationId.equals(conversationId),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
        limit: 6,
      );

      // Call AI service
      final aiService = AITranslationService(session);
      final recommendations = await aiService.recommendEmojis(
        partialText: partialText,
        tone: tone,
        personaId: personaId,
        conversationContext: contextMessages.reversed.toList(),
      );

      return recommendations;
    } catch (e) {
      session.log('Error getting recommendations: $e', level: LogLevel.error);
      
      // Return fallback recommendations
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