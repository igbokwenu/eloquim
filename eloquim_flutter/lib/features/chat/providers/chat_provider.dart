// eloquim_flutter/lib/features/chat/providers/chat_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../../core/providers/serverpod_client_provider.dart';

// Chat state model
class ChatState {
  final List<Message> messages;
  final bool isLoading;
  final bool isTyping;
  final String currentTone;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isTyping = false,
    this.currentTone = 'casual',
    this.error,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    bool? isTyping,
    String? currentTone,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isTyping: isTyping ?? this.isTyping,
      currentTone: currentTone ?? this.currentTone,
      error: error,
    );
  }
}

// Current conversation ID provider
// Current conversation ID provider
final currentConversationIdProvider =
    NotifierProvider<ConversationIdNotifier, int?>(ConversationIdNotifier.new);

class ConversationIdNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  void set(int? value) => state = value;
}

// Chat notifier
class ChatNotifier extends AsyncNotifier<ChatState> {
  late final Client _client;
  int? _conversationId;
  StreamSubscription? _messageSubscription;

  @override
  Future<ChatState> build() async {
    _client = ref.read(serverpodClientProvider);
    _conversationId = ref.read(currentConversationIdProvider);

    if (_conversationId == null) {
      return const ChatState();
    }

    try {
      // Load initial messages
      final messages = await _client.chat.getMessages(
        _conversationId!,
        limit: 20,
      );

      // Subscribe to real-time updates
      _subscribeToMessages();

      // Cleanup on dispose
      ref.onDispose(() {
        _messageSubscription?.cancel();
      });

      return ChatState(messages: messages);
    } catch (e) {
      return ChatState(error: e.toString());
    }
  }

  /// Send a message with emoji translation
  Future<void> sendMessage(
    String rawIntent,
    List<String>? emojiOverride,
  ) async {
    if (_conversationId == null) return;

    final currentState = state.asData?.value ?? const ChatState();
    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.asData?.value;

    if (user == null) return;

    // Optimistic UI update
    final tempMessage = Message(
      id: -DateTime.now().millisecondsSinceEpoch, // Temporary negative ID
      conversationId: _conversationId!,
      senderId: user.id!,
      rawIntent: rawIntent,
      emojiSequence: emojiOverride ?? [],
      translatedText: rawIntent,
      tone: currentState.currentTone,
      personaUsed: user.personaId?.toString() ?? 'default',
      confidenceScore: 0.0,
      createdAt: DateTime.now(),
    );

    state = AsyncData(
      currentState.copyWith(
        messages: [...currentState.messages, tempMessage],
        isLoading: true,
      ),
    );

    try {
      // Send to server
      final sentMessage = await _client.chat.sendMessage(
        SendMessageRequest(
          conversationId: _conversationId!,
          rawIntent: rawIntent,
          emojiSequence: emojiOverride ?? [],
          tone: currentState.currentTone,
          personaId: user.personaId?.toString() ?? 'default',
        ),
      );

      // Replace temp message with server response
      final updatedMessages =
          currentState.messages.where((m) => m.id != tempMessage.id).toList()
            ..add(sentMessage);

      state = AsyncData(
        currentState.copyWith(
          messages: updatedMessages,
          isLoading: false,
        ),
      );
    } catch (e) {
      // Remove temp message on error
      final updatedMessages = currentState.messages
          .where((m) => m.id != tempMessage.id)
          .toList();

      state = AsyncData(
        currentState.copyWith(
          messages: updatedMessages,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Switch tone (for tone-morphing preview)
  void switchTone(String newTone) {
    final currentState = state.asData?.value ?? const ChatState();
    state = AsyncData(currentState.copyWith(currentTone: newTone));
  }

  /// Mark message as read
  Future<void> markAsRead(int messageId) async {
    if (_conversationId == null) return;

    try {
      await _client.chat.markAsRead(_conversationId!, messageId);
    } catch (e) {
      // Silent fail
    }
  }

  /// Subscribe to real-time messages
  void _subscribeToMessages() {
    if (_conversationId == null) return;

    _messageSubscription = _client.chat
        .streamChat(_conversationId!)
        .listen(
          (message) {
            final currentState = state.asData?.value ?? const ChatState();

            // Avoid duplicates
            if (!currentState.messages.any((m) => m.id == message.id)) {
              state = AsyncData(
                currentState.copyWith(
                  messages: [...currentState.messages, message],
                ),
              );
            }
          },
          onError: (error) {
            final currentState = state.asData?.value ?? const ChatState();
            state = AsyncData(
              currentState.copyWith(
                error: error.toString(),
              ),
            );
          },
        );
  }

  /// Refresh messages
  Future<void> refresh() async {
    if (_conversationId == null) return;

    try {
      final messages = await _client.chat.getMessages(
        _conversationId!,
        limit: 20,
      );
      final currentState = state.asData?.value ?? const ChatState();
      state = AsyncData(currentState.copyWith(messages: messages));
    } catch (e) {
      // Keep current state on error
    }
  }
}

// Provider
final chatProvider = AsyncNotifierProvider.autoDispose<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
