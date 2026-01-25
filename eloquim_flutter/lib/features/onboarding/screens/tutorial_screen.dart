// eloquim_flutter/lib/features/onboarding/screens/tutorial_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  int _currentStep = 0;
  final List<TutorialStep> _steps = [
    TutorialStep(
      title: 'Meet Adanna 👋',
      description:
          'Hi! I\'m Adanna, your guide to Eloquim. Let me show you how to speak in emoji!',
      demoEmoji: '👋😊',
      demoText: 'Hello! Nice to meet you!',
      instruction: 'This is how emojis translate to text',
    ),
    TutorialStep(
      title: 'Choose Your Tone 🎨',
      description:
          'The same emojis can mean different things based on your tone.',
      demoEmoji: '🔥',
      demoText: 'That\'s fire!',
      instruction: 'Swipe the tone selector to see how it changes',
    ),
    TutorialStep(
      title: 'Ghost Translation 👻',
      description: 'Long-press any message to see the translation details.',
      demoEmoji: '💯🔥',
      demoText: 'Absolutely amazing!',
      instruction: 'Try long-pressing this message',
    ),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _completeTutorial();
    }
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  Future<void> _completeTutorial() async {
    try {
      final client = ref.read(serverpodClientProvider);
      await client.user.completeTutorial();

      if (mounted) {
        context.go('/conversations');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorial ${_currentStep + 1}/${_steps.length}'),
        actions: [
          TextButton(
            onPressed: _skipTutorial,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
              ),
              const SizedBox(height: 32),

              // Step content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      step.description,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Demo message bubble
                    GestureDetector(
                      onLongPress: _currentStep == 2
                          ? () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('👻 Ghost Translation'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow('Emojis', step.demoEmoji),
                                      const SizedBox(height: 8),
                                      _buildDetailRow(
                                        'Translated',
                                        step.demoText,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildDetailRow('Tone', 'Casual'),
                                      const SizedBox(height: 8),
                                      _buildDetailRow('Confidence', '92%'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Got it!'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              step.demoEmoji,
                              style: const TextStyle(
                                fontSize: 48,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              step.demoText,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Instruction
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.amber),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              step.instruction,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Next button
              FilledButton(
                onPressed: _nextStep,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _currentStep < _steps.length - 1 ? 'Next' : 'Get Started!',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final String demoEmoji;
  final String demoText;
  final String instruction;

  const TutorialStep({
    required this.title,
    required this.description,
    required this.demoEmoji,
    required this.demoText,
    required this.instruction,
  });
}
