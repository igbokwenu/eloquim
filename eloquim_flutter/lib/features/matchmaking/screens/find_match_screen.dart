// eloquim_flutter/lib/features/matchmaking/screens/find_match_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../providers/match_provider.dart';
import '../../chat/providers/conversation_provider.dart';

class FindMatchScreen extends ConsumerStatefulWidget {
  const FindMatchScreen({super.key});

  @override
  ConsumerState<FindMatchScreen> createState() => _FindMatchScreenState();
}

class _FindMatchScreenState extends ConsumerState<FindMatchScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch potential matches when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchProvider.notifier).findMatches();
    });
  }

  Future<void> _acceptMatch(User match) async {
    try {
      // Create conversation with this user
      final conversation = await ref
          .read(conversationsProvider.notifier)
          .createConversation([match.id!], null);

      if (mounted) {
        // Navigate to chat
        context.go('/chat/${conversation.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _skipMatch() {
    ref.read(matchProvider.notifier).nextMatch();
  }

  @override
  Widget build(BuildContext context) {
    final matchAsync = ref.watch(matchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Match'),
      ),
      body: matchAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to find matches'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.read(matchProvider.notifier).findMatches(),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
        data: (currentMatch) {
          if (currentMatch == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '😔',
                    style: TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No more matches available',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () =>
                        ref.read(matchProvider.notifier).findMatches(),
                    child: const Text('Search Again'),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile card
                  Expanded(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Emoji signature
                            Text(
                              currentMatch.emojiSignature,
                              style: const TextStyle(fontSize: 80),
                            ),
                            const SizedBox(height: 24),

                            // Username
                            Text(
                              currentMatch.username,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Age and country
                            if (currentMatch.age != null ||
                                currentMatch.country != null)
                              Text(
                                [
                                  if (currentMatch.age != null)
                                    '${currentMatch.age}',
                                  if (currentMatch.country != null)
                                    currentMatch.country,
                                ].join(' • '),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            const SizedBox(height: 32),

                            // Compatibility score (placeholder)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.favorite, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text(
                                    '87% Compatible',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Skip button
                      FloatingActionButton.large(
                        onPressed: _skipMatch,
                        backgroundColor: Colors.red.shade100,
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),

                      // Accept button
                      FloatingActionButton.large(
                        onPressed: () => _acceptMatch(currentMatch),
                        backgroundColor: Colors.green.shade100,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
