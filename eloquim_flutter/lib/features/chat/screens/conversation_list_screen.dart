// eloquim_flutter/lib/features/chat/screens/conversation_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../providers/conversation_provider.dart';
import '../../../core/providers/serverpod_client_provider.dart';
import '../../../shared/widgets/token_usage_bottom_sheet.dart';

class ConversationListScreen extends ConsumerWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Eloquim'),
            const Text(
              'v0.0.7',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
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

class _ConversationCard extends ConsumerWidget {
  final Conversation conversation;

  const _ConversationCard({required this.conversation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.asData?.value;

    String? displayTitle = conversation.title;
    int? otherId;

    if (conversation.type == 'p2p' && currentUser != null) {
      otherId = conversation.participantIds.firstWhere(
        (id) => id != currentUser.id,
        orElse: () => -1,
      );
    }

    final otherUserAsync = otherId != null && otherId != -1
        ? ref.watch(userProvider(otherId))
        : const AsyncValue.data(null);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: otherUserAsync.when(
            data: (user) => Text(user?.username[0] ?? displayTitle?[0] ?? '?'),
            loading: () => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) => Text(displayTitle?[0] ?? '?'),
          ),
        ),
        title: otherUserAsync.when(
          data: (user) {
            final name = user?.username ?? displayTitle ?? 'Conversation';
            final botSuffix = (user?.isBot ?? false) ? ' (AI Bot)' : '';
            return Text(
              '$name$botSuffix',
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          },
          loading: () => Text(displayTitle ?? 'Loading...'),
          error: (_, __) => Text(displayTitle ?? 'Conversation'),
        ),
        subtitle: Row(
          children: [
            Text(
              _formatTime(conversation.lastMessageAt),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const Spacer(),
            if (conversation.status == 'archived')
              const Icon(Icons.archive_outlined, size: 14, color: Colors.grey),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
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
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
