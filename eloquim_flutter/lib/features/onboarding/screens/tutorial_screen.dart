// eloquim_flutter/lib/features/onboarding/screens/tutorial_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/serverpod_client_provider.dart';
import '../../../shared/constants/tone_constants.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  int _currentStep = 0;
  String _activeTone = 'casual';

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
      title: 'Tone Morphing 🎨',
      description:
          'The same emojis mean different things depending on your tone. Try switching tones below!',
      demoEmoji: '👋',
      demoText: 'Hey there!',
      instruction: 'Tap a tone to see how the translation shifts',
      multiToneDemo: {
        'casual': 'Hey there! How\'s it going?',
        'flirty': 'Hey cutie, how\'s your day going? 😉',
        'formal': 'Good day. I hope this message finds you well.',
        'enthusiastic': 'HIIII! SO HAPPY TO CONNECT WITH YOU!! 🎉',
        'cold': 'Hello.',
      },
    ),
    TutorialStep(
      title: 'Quick Responses ✨',
      description:
          'AI suggests emojis you can use to reply instantly. Just tap them to send!',
      demoEmoji: '🙏✨',
      demoText: 'Thank you so much!',
      instruction: 'Look for suggested emojis above the keyboard',
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
        ref.invalidate(currentUserProvider);
        await ref.read(currentUserProvider.future);
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
              LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      step.description,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    GestureDetector(
                      onLongPress: _currentStep == 3
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
                                        step.multiToneDemo?[_activeTone] ??
                                            step.demoText,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildDetailRow(
                                        'Tone',
                                        'enthusiastic',
                                      ),
                                      const SizedBox(height: 8),
                                      _buildDetailRow('Confidence', '98%'),
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
                              step.multiToneDemo?[_activeTone] ?? step.demoText,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (step.multiToneDemo != null) ...[
                      _buildToneSelector(),
                      const SizedBox(height: 24),
                    ],
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
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Widget _buildToneSelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ToneConstants.tones.length,
        itemBuilder: (context, index) {
          final tone = ToneConstants.tones[index];
          final isSelected = tone == _activeTone;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text('${ToneConstants.toneEmojis[tone] ?? ''} $tone'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _activeTone = tone);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final String demoEmoji;
  final String demoText;
  final String instruction;
  final Map<String, String>? multiToneDemo;

  const TutorialStep({
    required this.title,
    required this.description,
    required this.demoEmoji,
    required this.demoText,
    required this.instruction,
    this.multiToneDemo,
  });
}
