// eloquim_flutter/lib/features/chat/providers/conversation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class ConversationsNotifier extends AsyncNotifier<List<Conversation>> {
  @override
  Future<List<Conversation>> build() async {
    final client = ref.read(serverpodClientProvider);

    try {
      final conversations = await client.conversation.getConversations();
      return conversations;
    } catch (e) {
      return [];
    }
  }

  Future<Conversation> createConversation(
    List<int> participantIds,
    String? title,
  ) async {
    final client = ref.read(serverpodClientProvider);

    final conversation = await client.conversation.createConversation(
      participantIds,
      title,
    );

    // Refresh list
    ref.invalidateSelf();

    return conversation;
  }

  Future<void> archiveConversation(int conversationId) async {
    final client = ref.read(serverpodClientProvider);

    await client.conversation.archiveConversation(conversationId);

    // Refresh list
    ref.invalidateSelf();
  }

  Future<void> deleteConversation(int conversationId) async {
    final client = ref.read(serverpodClientProvider);

    await client.conversation.deleteConversation(conversationId);

    // Refresh list
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final conversationsProvider =
    AsyncNotifierProvider.autoDispose<
      ConversationsNotifier,
      List<Conversation>
    >(
      ConversationsNotifier.new,
    );
