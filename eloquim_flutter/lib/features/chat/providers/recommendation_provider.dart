// eloquim_flutter/lib/features/chat/providers/recommendation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../../core/providers/serverpod_client_provider.dart';
import 'chat_provider.dart';

class RecommendationNotifier extends AutoDisposeAsyncNotifier<RecommendationResponse> {
  @override
  Future<RecommendationResponse> build() async {
    // Return empty initial state
    return RecommendationResponse(
      singles: [],
      combos: [],
    );
  }

  Future<void> getRecommendations(String partialText) async {
    if (partialText.isEmpty) {
      state = AsyncData(RecommendationResponse(singles: [], combos: []));
      return;
    }

    final client = ref.read(serverpodClientProvider);
    final conversationId = ref.read(currentConversationIdProvider);
    final chatState = ref.read(chatProvider).valueOrNull;

    if (conversationId == null) return;

    try {
      final recommendations = await client.recommendation.getRecommendations(
        conversationId,
        partialText,
        chatState?.currentTone ?? 'casual',
        'default', // TODO: Get from user persona
      );

      state = AsyncData(recommendations);
    } catch (e) {
      // Keep current state on error, or provide fallback
      state = AsyncData(RecommendationResponse(
        singles: ['😊', '👍', '😂', '❤️', '🔥', '✨'],
        combos: [],
      ));
    }
  }

  void clear() {
    state = AsyncData(RecommendationResponse(singles: [], combos: []));
  }
}

final recommendationsProvider = AutoDisposeAsyncNotifierProvider<
    RecommendationNotifier,
    RecommendationResponse>(
  RecommendationNotifier.new,
);