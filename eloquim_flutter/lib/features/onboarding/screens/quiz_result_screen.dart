// eloquim_flutter/lib/features/onboarding/screens/quiz_result_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  final String assignedPersona;

  const QuizResultScreen({
    required this.assignedPersona,
    super.key,
  });

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _assignPersona();
  }

  Future<void> _assignPersona() async {
    setState(() => _isLoading = true);

    try {
      final client = ref.read(serverpodClientProvider);

      // Get official personas
      final personas = await client.persona.getOfficialPersonas();

      // Find matching persona
      final matchingPersona = personas.firstWhere(
        (p) => p.name == widget.assignedPersona,
        orElse: () => personas.first,
      );

      // Assign to user
      await client.persona.assignPersona(matchingPersona.id!);

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final personaInfo = _getPersonaInfo(widget.assignedPersona);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Persona emoji
              Text(
                personaInfo['emoji'] as String,
                style: const TextStyle(fontSize: 100),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Your Persona',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Persona name
              Text(
                widget.assignedPersona,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                personaInfo['description'] as String,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Emoji signature
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Your Emoji Signature',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        personaInfo['signature'] as String,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Continue button
              if (!_isLoading)
                FilledButton(
                  onPressed: () => context.go('/tutorial'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Continue to Tutorial',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getPersonaInfo(String personaName) {
    switch (personaName) {
      case 'Gen Z':
        return {
          'emoji': '✨',
          'description':
              'Casual, playful, and meme-fluent. You express yourself with modern vibes and authenticity.',
          'signature': '✨🎵💫',
        };
      case 'Professional':
        return {
          'emoji': '💼',
          'description':
              'Formal, clear, and respectful. You communicate with precision and professionalism.',
          'signature': '💼📊🎯',
        };
      case 'Romantic':
        return {
          'emoji': '💖',
          'description':
              'Poetic, emotional, and expressive. You wear your heart on your sleeve.',
          'signature': '💖✨🌙',
        };
      default:
        return {
          'emoji': '✨',
          'description': 'Your unique communication style.',
          'signature': '✨🎵💫',
        };
    }
  }
}
