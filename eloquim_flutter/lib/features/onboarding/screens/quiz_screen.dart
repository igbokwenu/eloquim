// eloquim_flutter/lib/features/onboarding/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int currentQuestion = 0;
  Map<int, String> answers = {};

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'How do you usually express yourself?',
      'options': [
        {'emoji': '😊', 'text': 'Casual & friendly', 'persona': 'Gen Z'},
        {
          'emoji': '💼',
          'text': 'Professional & clear',
          'persona': 'Professional',
        },
        {
          'emoji': '💕',
          'text': 'Emotional & expressive',
          'persona': 'Romantic',
        },
      ],
    },
    {
      'question': 'Your ideal conversation is:',
      'options': [
        {'emoji': '🎮', 'text': 'Fun & playful', 'persona': 'Gen Z'},
        {
          'emoji': '📊',
          'text': 'Structured & focused',
          'persona': 'Professional',
        },
        {'emoji': '🌙', 'text': 'Deep & meaningful', 'persona': 'Romantic'},
      ],
    },
    {
      'question': 'When sharing news:',
      'options': [
        {'emoji': '🔥', 'text': 'Hype it up!', 'persona': 'Gen Z'},
        {'emoji': '✅', 'text': 'State the facts', 'persona': 'Professional'},
        {'emoji': '✨', 'text': 'Share the feeling', 'persona': 'Romantic'},
      ],
    },
    {
      'question': 'Your emoji style:',
      'options': [
        {'emoji': '😂💯', 'text': 'Multiple emojis', 'persona': 'Gen Z'},
        {'emoji': '👍', 'text': 'One is enough', 'persona': 'Professional'},
        {'emoji': '💖✨', 'text': 'Expressive combos', 'persona': 'Romantic'},
      ],
    },
    {
      'question': 'Communication goal:',
      'options': [
        {'emoji': '🎉', 'text': 'Have fun', 'persona': 'Gen Z'},
        {'emoji': '🎯', 'text': 'Be effective', 'persona': 'Professional'},
        {'emoji': '💫', 'text': 'Connect deeply', 'persona': 'Romantic'},
      ],
    },
  ];

  void selectAnswer(String persona) {
    setState(() {
      answers[currentQuestion] = persona;
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        // Quiz complete - determine persona
        _completeQuiz();
      }
    });
  }

  void _completeQuiz() {
    // Count persona occurrences
    final personaCounts = <String, int>{};
    for (final persona in answers.values) {
      personaCounts[persona] = (personaCounts[persona] ?? 0) + 1;
    }

    // Find most common
    String assignedPersona = 'Gen Z';
    int maxCount = 0;
    personaCounts.forEach((persona, count) {
      if (count > maxCount) {
        maxCount = count;
        assignedPersona = persona;
      }
    });

    // Navigate to result
    context.go('/quiz-result', extra: assignedPersona);
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestion + 1}/${questions.length}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (currentQuestion + 1) / questions.length,
              ),
              const SizedBox(height: 32),
              // Question
              Text(
                question['question'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Options
              ...List.generate(
                question['options'].length,
                (index) {
                  final option = question['options'][index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      child: InkWell(
                        onTap: () => selectAnswer(option['persona']),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Text(
                                option['emoji'],
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  option['text'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
