import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class ConversationsNotifier extends AsyncNotifier<List<Conversation>> {
  StreamSubscription? _subscription;

  @override
  Future<List<Conversation>> build() async {
    final client = ref.read(serverpodClientProvider);
    final userAsync = ref.watch(currentUserProvider);

    // Cancel old subscription if any
    _subscription?.cancel();

    final user = userAsync.asData?.value;

    if (user != null) {
      _subscribeToNotifications(client, user.id!);
    }

    ref.onDispose(() {
      _subscription?.cancel();
    });

    try {
      final conversations = await client.conversation.getConversations();
      return conversations;
    } catch (e) {
      return [];
    }
  }

  void _subscribeToNotifications(Client client, int userId) {
    unawaited(client.openStreamingConnection());
    _subscription = client.conversation.listenToSystemNotifications().listen((
      notification,
    ) {
      if (notification.type == 'new_conversation') {
        ref.invalidateSelf();
      }
    });
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
