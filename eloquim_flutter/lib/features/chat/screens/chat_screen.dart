// eloquim_flutter/lib/features/chat/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_composer.dart';

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

  @override
  void initState() {
    super.initState();
    // Set current conversation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(currentConversationIdProvider.notifier)
          .set(widget.conversationId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      appBar: AppBar(
        title: const Text('Chat'),
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
            onPressed: () {
              // Show conversation info
            },
          ),
        ],
      ),
      body: chatAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (chatState) {
          // Scroll to bottom when new messages arrive
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Column(
            children: [
              // Messages list
              Expanded(
                child: chatState.messages.isEmpty
                    ? const Center(
                        child: Text(
                          'Start the conversation! 👋\nUse the emoji keyboard below.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount:
                            chatState.messages.length +
                            (chatState.isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == chatState.messages.length) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Eloquim is thinking...',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }
                          final message = chatState.messages[index];
                          return ChatBubble(message: message);
                        },
                      ),
              ),

              // Message composer
              MessageComposer(
                history: chatState.messages,
                onSend: (text, emojis) async {
                  await ref
                      .read(chatProvider.notifier)
                      .sendMessage(text, emojis);
                },
                currentTone: chatState.currentTone,
                onToneChanged: (tone) {
                  ref.read(chatProvider.notifier).switchTone(tone);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
