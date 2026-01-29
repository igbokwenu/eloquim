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
  int? _conversationId;
  StreamSubscription? _messageSubscription;
  final _aiService = AIService();

  @override
  Future<ChatState> build() async {
    final client = ref.read(serverpodClientProvider);
    _conversationId = ref.watch(currentConversationIdProvider);

    if (_conversationId == null) {
      return const ChatState();
    }

    try {
      final messages = await client.chat.getMessages(
        _conversationId!,
        limit: 50,
      );

      _subscribeToMessages();

      ref.onDispose(() {
        _messageSubscription?.cancel();
      });

      return ChatState(messages: messages);
    } catch (e) {
      debugPrint('Error loading chat history: $e');
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

    // 1. Optimistic message placeholder
    final tempMessage = Message(
      id: -DateTime.now().millisecondsSinceEpoch,
      conversationId: _conversationId!,
      senderId: user.id!,
      rawIntent: rawIntent,
      emojiSequence: emojiOverride ?? [],
      translatedText: '...', // Placeholder
      tone: currentState.currentTone,
      personaUsed: user.personaId?.toString() ?? 'default',
      confidenceScore: 0.0,
      createdAt: DateTime.now(),
    );

    // Show "Creating Soul Packet" immediately
    state = AsyncData(
      currentState.copyWith(
        messages: [...currentState.messages, tempMessage],
        isTyping: true,
      ),
    );

    try {
      // 2. Call AI translation service
      final translation = await _aiService.translateEmojis(
        emojiSequence: emojiOverride ?? [],
        tone: currentState.currentTone,
        sender: user,
        context: currentState.messages,
      );

      final client = ref.read(serverpodClientProvider);

      // 3. Send to server
      final sentMessage = await client.chat.sendMessage(
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

      // Log token usage
      if (translation['totalTokens'] != null &&
          translation['totalTokens'] > 0) {
        unawaited(
          client.user.logTokenUsage(
            userId: user.id!,
            tokenCount: translation['totalTokens'],
            apiCallType: 'translation',
          ),
        );
      }

      // 4. Update state with real message
      final latestState = state.asData?.value ?? currentState;

      // Remove the temp message
      final List<Message> filteredMessages = latestState.messages
          .where((m) => m.id != tempMessage.id)
          .toList();

      // Only add sentMessage if it hasn't already been added by the stream
      if (!filteredMessages.any((m) => m.id == sentMessage.id)) {
        filteredMessages.add(sentMessage);
      }

      state = AsyncData(
        latestState.copyWith(
          messages: filteredMessages,
          isTyping: false,
        ),
      );

      // 5. Trigger bot reply if the recipient is a bot
      _triggerBotReplyIfNecessary(sentMessage, user);
    } catch (e) {
      debugPrint('Error sending message: $e');
      final latestState = state.asData?.value ?? currentState;
      final updatedMessages = latestState.messages
          .where((m) => m.id != tempMessage.id)
          .toList();

      state = AsyncData(
        latestState.copyWith(
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

    final client = ref.read(serverpodClientProvider);

    // Ensure connection is open
    unawaited(client.openStreamingConnection());

    _messageSubscription?.cancel();
    _messageSubscription = client.chat
        .streamChat(_conversationId!)
        .listen(
          (message) async {
            final currentState = state.asData?.value ?? const ChatState();

            // Prevent duplicates
            if (!currentState.messages.any((m) => m.id == message.id)) {
              state = AsyncData(
                currentState.copyWith(
                  messages: [...currentState.messages, message],
                ),
              );
            }
          },
          onError: (error) {
            debugPrint('Chat stream error: $error');
            // Attempt to reconnect after a delay
            Future.delayed(const Duration(seconds: 2), () {
              if (state.hasValue && _conversationId != null) {
                _subscribeToMessages();
              }
            });
          },
          cancelOnError: false,
        );
  }

  void _triggerBotReplyIfNecessary(
    Message lastMessage,
    User currentUser,
  ) async {
    if (_conversationId == null) return;

    final client = ref.read(serverpodClientProvider);

    try {
      // Fetch conversation to get participant list
      final conversation = await client.conversation.getConversation(
        _conversationId!,
      );
      if (conversation == null) return;

      // Find the participant who is NOT the current user
      final otherId = conversation.participantIds.firstWhere(
        (id) => id != currentUser.id,
        orElse: () => -1,
      );

      if (otherId != -1) {
        final otherUser = await client.user.getUser(otherId);
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

    final client = ref.read(serverpodClientProvider);

    state = AsyncData(currentState.copyWith(isTyping: true));

    try {
      final (botReply, tokens) = await _aiService.generateBotResponse(
        botUser: botUser,
        history: currentState.messages,
        currentUser: currentUser,
        onToolCall: (name, args) async {
          switch (name) {
            case 'getTutorialStatus':
              return {'hasDoneTutorial': currentUser.hasDoneTutorial};
            case 'markTutorialFinished':
              await client.user.completeTutorial();
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
        await client.chat.sendMessage(
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

        if (tokens > 0) {
          unawaited(
            client.user.logTokenUsage(
              userId: currentUser.id!,
              tokenCount: tokens,
              apiCallType: 'bot_response',
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error in bot response: $e');
    } finally {
      // Use current state to preserve messages
      final latestState = state.asData?.value ?? currentState;
      state = AsyncData(latestState.copyWith(isTyping: false));
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

    final client = ref.read(serverpodClientProvider);

    try {
      await client.chat.markAsRead(_conversationId!, messageId);
    } catch (e) {
      // Silent fail
    }
  }

  /// Refresh messages
  Future<void> refresh() async {
    if (_conversationId == null) return;

    final client = ref.read(serverpodClientProvider);

    try {
      final messages = await client.chat.getMessages(
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
