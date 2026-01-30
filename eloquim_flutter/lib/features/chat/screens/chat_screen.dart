// eloquim_flutter/lib/features/chat/screens/chat_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_composer.dart';
import '../../../shared/widgets/token_usage_bottom_sheet.dart';
import '../services/chat_genui_service.dart';
import '../../../core/providers/serverpod_client_provider.dart';
import 'package:genui/genui.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final int conversationId;

  const ChatScreen({
    required this.conversationId,
    super.key,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _genUiSurfaceIds = [];
  late final ChatGenUiService _genUiService;

  @override
  void initState() {
    super.initState();
    _genUiService = ChatGenUiService(
      onSurfaceAdded: (id) {
        if (mounted)
          setState(() {
            if (!_genUiSurfaceIds.contains(id)) _genUiSurfaceIds.add(id);
          });
        _scrollToBottom();
      },
      onSurfaceUpdated: (id) {
        if (mounted) setState(() {}); // Trigger rebuild for updated surface
        _scrollToBottom();
      },
      onSurfaceRemoved: (id) {
        if (mounted) setState(() => _genUiSurfaceIds.remove(id));
      },
      onTextResponse: (text) {
        debugPrint('GenUI Text Response: $text');
      },
    );

    // Set current conversation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(currentConversationIdProvider.notifier)
          .set(widget.conversationId);
    });
  }

  @override
  void dispose() {
    _genUiService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isAtmosphere(String id) => id.contains('atmosphere');
  bool _isSuggestions(String id) => id.contains('suggestions');
  bool _isRegularSurface(String id) =>
      !_isAtmosphere(id) && !_isSuggestions(id);

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Chat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/conversations');
            }
          },
        ),
        actions: [
          // Find New Match Button
          TextButton.icon(
            onPressed: () => context.push('/find-match'),
            icon: const Icon(Icons.person_add_outlined),
            label: const Text('New Match'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => TokenUsageBottomSheet.show(context),
          ),
        ],
      ),
      body: chatAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: SelectionArea(child: Text('Error: $error'))),
        data: (chatState) {
          // Listen for new partner messages to update GenUI suggestions/atmosphere
          ref.listen(chatProvider, (previous, next) {
            final prevMessages = previous?.asData?.value.messages ?? [];
            final nextMessages = next.asData?.value.messages ?? [];
            if (nextMessages.length > prevMessages.length) {
              final lastMsg = nextMessages.last;
              // If it's from partner, notify GenUI to update suggestions
              final currentUser = ref.read(currentUserProvider).asData?.value;
              if (lastMsg.senderId != currentUser?.id) {
                _genUiService.updateWithNewMessage(
                  lastMsg.translatedText,
                  chatState.currentTone,
                  isFromUser: false,
                );
              }
            }
          });

          // Scroll to bottom when new messages arrive
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          final regularSurfaces = _genUiSurfaceIds
              .where(_isRegularSurface)
              .toList();
          final atmosphereId = _genUiSurfaceIds
              .where(_isAtmosphere)
              .firstOrNull;
          final suggestionsId = _genUiSurfaceIds
              .where(_isSuggestions)
              .firstOrNull;

          return Stack(
            children: [
              // 1. Base Layer (Theme Background)
              Positioned.fill(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),

              // 2. Atmosphere Background (GenUI Layer)
              if (atmosphereId != null)
                Positioned.fill(
                  key: ValueKey('atmosphere_$atmosphereId'),
                  child: GenUiSurface(
                    host:
                        _genUiService.processor, // Use the processor explicitly
                    surfaceId: atmosphereId,
                  ),
                ),

              // 3. Subtle Overlay to ensure readability
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.1)),
              ),

              // 3. Chat UI (Foreground Layer)
              SafeArea(
                child: Column(
                  children: [
                    // Messages list
                    Expanded(
                      child: SelectionArea(
                        child:
                            chatState.messages.isEmpty &&
                                regularSurfaces.isEmpty
                            ? const Center(
                                child: Text(
                                  'Start the conversation! 👋\nUse the emoji keyboard below.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(8),
                                itemCount:
                                    chatState.messages.length +
                                    regularSurfaces.length +
                                    (chatState.isTyping ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index < chatState.messages.length) {
                                    final message = chatState.messages[index];
                                    return ChatBubble(message: message);
                                  } else if (index <
                                      chatState.messages.length +
                                          regularSurfaces.length) {
                                    final surfaceId =
                                        regularSurfaces[index -
                                            chatState.messages.length];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: GenUiSurface(
                                        host: _genUiService
                                            .processor, // Use the processor explicitly

                                        surfaceId: surfaceId,
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '✨ Creating Soul Packet...',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                      ),
                    ),

                    // Smart Suggestions (GenUI generated)
                    if (suggestionsId != null)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GenUiSurface(
                          host: _genUiService
                              .processor, // Use the processor explicitly
                          surfaceId: suggestionsId,
                        ),
                      ),

                    // Message composer
                    MessageComposer(
                      history: chatState.messages,
                      onSend: (text, emojis) async {
                        unawaited(
                          _genUiService.updateWithNewMessage(
                            text,
                            chatState.currentTone,
                          ),
                        );

                        await ref
                            .read(chatProvider.notifier)
                            .sendMessage(text, emojis);
                      },
                      currentTone: chatState.currentTone,
                      onToneChanged: (tone) {
                        ref.read(chatProvider.notifier).switchTone(tone);
                        _genUiService.onToneChanged(tone);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
