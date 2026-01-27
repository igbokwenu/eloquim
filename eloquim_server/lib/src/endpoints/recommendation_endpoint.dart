// eloquim_server/lib/src/endpoints/recommendation_endpoint.dart
import 'package:serverpod/serverpod.dart' hide Message;
import '../generated/protocol.dart';

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

    // Return static fallbacks. In Eloquim V2, the client handles
    // real-time dynamic recommendations via Firebase AI.
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
