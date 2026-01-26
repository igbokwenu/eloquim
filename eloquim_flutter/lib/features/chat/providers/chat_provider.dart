import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../../core/providers/serverpod_client_provider.dart';
import '../../../core/services/ai_service.dart';

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
  final _aiService = AIService();

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

    // Call AI translation service on client
    final translation = await _aiService.translateEmojis(
      emojiSequence: emojiOverride ?? [],
      tone: currentState.currentTone,
      sender: user,
      context: currentState.messages,
    );

    // Optimistic UI update
    final tempMessage = Message(
      id: -DateTime.now().millisecondsSinceEpoch,
      conversationId: _conversationId!,
      senderId: user.id!,
      rawIntent: rawIntent,
      emojiSequence: emojiOverride ?? [],
      translatedText: translation['text'] ?? rawIntent,
      tone: currentState.currentTone,
      personaUsed: user.personaId?.toString() ?? 'default',
      confidenceScore: (translation['confidence'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.now(),
    );

    state = AsyncData(
      currentState.copyWith(
        messages: [...currentState.messages, tempMessage],
        isTyping: true,
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
          translatedText: translation['text'],
          confidenceScore: (translation['confidence'] as num?)?.toDouble(),
          recommendedEmojis: List<String>.from(
            translation['recommendations'] ?? [],
          ),
        ),
      );

      // Replace temp message with server response
      final updatedMessages =
          currentState.messages.where((m) => m.id != tempMessage.id).toList()
            ..add(sentMessage);

      state = AsyncData(
        currentState.copyWith(
          messages: updatedMessages,
          isTyping: false,
        ),
      );

      // Trigger bot reply if the recipient is a bot
      _triggerBotReplyIfNecessary(sentMessage, user);
    } catch (e) {
      final updatedMessages = currentState.messages
          .where((m) => m.id != tempMessage.id)
          .toList();

      state = AsyncData(
        currentState.copyWith(
          messages: updatedMessages,
          isTyping: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Subscribe to real-time messages
  void _subscribeToMessages() {
    if (_conversationId == null) return;

    _messageSubscription = _client.chat
        .streamChat(_conversationId!)
        .listen(
          (message) async {
            final currentState = state.asData?.value ?? const ChatState();

            if (!currentState.messages.any((m) => m.id == message.id)) {
              state = AsyncData(
                currentState.copyWith(
                  messages: [...currentState.messages, message],
                ),
              );

              // Check if we should trigger a bot response

              // Only trigger from stream if it's a message from someone ELSE
              // (In case of human partners, we don't trigger AI.
              // If it's a bot, the bot's own message doesn't trigger another reply).
              // The primary trigger for bots is when the CURRENT user sends a message.
            }
          },
          onError: (error) {
            final currentState = state.asData?.value ?? const ChatState();
            state = AsyncData(currentState.copyWith(error: error.toString()));
          },
        );
  }

  void _triggerBotReplyIfNecessary(
    Message lastMessage,
    User currentUser,
  ) async {
    if (_conversationId == null) return;

    try {
      // Fetch conversation to get participant list
      final conversation = await _client.conversation.getConversation(
        _conversationId!,
      );
      if (conversation == null) return;

      // Find the participant who is NOT the current user
      final otherId = conversation.participantIds.firstWhere(
        (id) => id != currentUser.id,
        orElse: () => -1,
      );

      if (otherId != -1) {
        final otherUser = await _client.user.getUser(otherId);
        if (otherUser != null && otherUser.isBot) {
          await triggerBotResponse(otherUser);
        }
      }
    } catch (e) {
      debugPrint('Error in bot reply check: $e');
    }
  }

  /// Trigger a bot reply if the recipient is a bot
  Future<void> triggerBotResponse(User botUser) async {
    final currentState = state.asData?.value ?? const ChatState();
    final userAsync = ref.read(currentUserProvider);
    final currentUser = userAsync.asData?.value;
    if (currentUser == null) return;

    state = AsyncData(currentState.copyWith(isTyping: true));

    final botReply = await _aiService.generateBotResponse(
      botUser: botUser,
      history: currentState.messages,
      currentUser: currentUser,
      onToolCall: (name, args) async {
        switch (name) {
          case 'getTutorialStatus':
            return {'hasDoneTutorial': currentUser.hasDoneTutorial};
          case 'markTutorialFinished':
            await _client.user.completeTutorial();
            return {'success': true};
          case 'navigateToFindMatch':
            ref.read(botActionProvider.notifier).set('navigateToFindMatch');
            return {'navigated': true};
          default:
            return {'error': 'Unknown tool'};
        }
      },
    );

    if (botReply != null) {
      try {
        await _client.chat.sendMessage(
          SendMessageRequest(
            conversationId: _conversationId!,
            rawIntent: botReply.translatedText,
            emojiSequence: botReply.emojiSequence,
            tone: 'casual',
            personaId: botUser.personaId?.toString() ?? 'bot',
            translatedText: botReply.translatedText,
            confidenceScore: 1.0,
            recommendedEmojis: botReply.recommendedEmojis,
          ),
        );
      } catch (e) {
        debugPrint('Error sending bot reply: $e');
      }
    }

    state = AsyncData(state.asData!.value.copyWith(isTyping: false));
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

// Bot Actions Provider for UI navigation
class BotActionNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? value) => state = value;
}

final botActionProvider = NotifierProvider<BotActionNotifier, String?>(
  BotActionNotifier.new,
);
