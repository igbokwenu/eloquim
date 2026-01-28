// eloquim_flutter/lib/features/chat/screens/conversation_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../providers/conversation_provider.dart';
import '../../../shared/widgets/token_usage_bottom_sheet.dart';

class ConversationListScreen extends ConsumerWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eloquim'),
        actions: [
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
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: conversationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '✨ No conversations yet',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.push('/find-match'),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Find a Match'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return _ConversationCard(conversation: conversation);
            },
          );
        },
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final Conversation conversation;

  const _ConversationCard({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(conversation.title?[0] ?? '?'),
        ),
        title: Text(conversation.title ?? 'Conversation'),
        subtitle: Text(
          _formatTime(conversation.lastMessageAt),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push('/chat/${conversation.id}');
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
