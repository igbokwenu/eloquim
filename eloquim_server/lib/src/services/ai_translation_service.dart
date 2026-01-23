// eloquim_server/lib/src/services/ai_translation_service.dart
import 'dart:convert';
import 'package:serverpod/serverpod.dart' hide Message;
import '../generated/protocol.dart';
import 'package:http/http.dart' as http;

class TranslationResult {
  final String text;
  final double confidence;

  const TranslationResult({
    required this.text,
    required this.confidence,
  });
}

class AITranslationService {
  final Session session;
  
  // You'll need to set this in environment variables
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  AITranslationService(this.session);

  /// Translate emojis to text using Gemini (simplified for V1)
  Future<TranslationResult> translateEmojis({
    required List<String> emojiSequence,
    required String tone,
    required String personaId,
    required List<Message> conversationContext,
  }) async {
    try {
      // Build conversation context
      final contextText = conversationContext
          .take(6)
          .map((m) => '${m.emojiSequence.join('')}: ${m.translatedText}')
          .join('\n');

      final prompt = _buildTranslationPrompt(
        emojiSequence: emojiSequence,
        tone: tone,
        personaId: personaId,
        contextText: contextText,
      );

      // For V1, we'll use a simple rule-based fallback
      // In production, you'd call Firebase/Gemini API here
      final translatedText = await _callGeminiAPI(prompt) ?? 
                             _fallbackTranslation(emojiSequence, tone);

      final confidence = _calculateConfidence(emojiSequence, translatedText);

      return TranslationResult(
        text: translatedText,
        confidence: confidence,
      );
    } catch (e) {
      session.log('Translation error: $e', level: LogLevel.error);
      return TranslationResult(
        text: _fallbackTranslation(emojiSequence, tone),
        confidence: 0.5,
      );
    }
  }

  /// Get emoji recommendations
  Future<RecommendationResponse> recommendEmojis({
    required String partialText,
    required String tone,
    required String personaId,
    required List<Message> conversationContext,
  }) async {
    try {
      final contextText = conversationContext
          .take(6)
          .map((m) => '${m.emojiSequence.join('')}: ${m.translatedText}')
          .join('\n');

      final prompt = _buildRecommendationPrompt(
        partialText: partialText,
        tone: tone,
        personaId: personaId,
        contextText: contextText,
      );

      final response = await _callGeminiAPI(prompt);
      
      if (response != null) {
        return _parseRecommendations(response);
      }
    } catch (e) {
      session.log('Recommendation error: $e', level: LogLevel.error);
    }

    // Fallback recommendations
    return _fallbackRecommendations(partialText, tone);
  }

  String _buildTranslationPrompt({
    required List<String> emojiSequence,
    required String tone,
    required String personaId,
    required String contextText,
  }) {
    return '''You are Eloquim, an AI that translates emoji sequences into natural language.

Persona: $personaId
Tone: $tone
${contextText.isNotEmpty ? 'Conversation context:\n$contextText\n' : ''}
Current emoji sequence: ${emojiSequence.join(' ')}

Translate this emoji sequence into natural language that:
1. Matches the specified tone and persona
2. Considers the conversation context
3. Captures the emotional intent behind the emojis
4. Sounds natural and authentic

Return ONLY the translated text, nothing else.''';
  }

  String _buildRecommendationPrompt({
    required String partialText,
    required String tone,
    required String personaId,
    required String contextText,
  }) {
    return '''You are Eloquim's suggestion engine.

Persona: $personaId
Tone: $tone
${contextText.isNotEmpty ? 'Conversation context:\n$contextText\n' : ''}
User is typing: "$partialText"

Suggest:
1. 6 single emojis that would fit naturally
2. 3 emoji combinations (2-3 emojis each) that express complex emotions

Format as JSON:
{
  "singles": ["emoji1", "emoji2", "emoji3", "emoji4", "emoji5", "emoji6"],
  "combos": [
    {"emojis": ["emoji1", "emoji2"], "meaning": "short description"},
    {"emojis": ["emoji3", "emoji4"], "meaning": "short description"},
    {"emojis": ["emoji5", "emoji6"], "meaning": "short description"}
  ]
}''';
  }

  Future<String?> _callGeminiAPI(String prompt) async {
    if (_apiKey.isEmpty) {
      return null; // No API key, use fallback
    }

    try {
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 200,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      }
    } catch (e) {
      session.log('Gemini API error: $e', level: LogLevel.warning);
    }

    return null;
  }

  String _fallbackTranslation(List<String> emojis, String tone) {
    if (emojis.isEmpty) return '';
    
    // Simple emoji-to-text mapping
    final Map<String, String> basicMappings = {
      '👋': 'Hello',
      '😊': 'happy',
      '😂': 'laughing',
      '❤️': 'love',
      '🔥': 'fire',
      '💯': 'perfect',
      '👍': 'great',
      '🎉': 'celebrate',
      '😍': 'love it',
      '🤔': 'thinking',
      '💭': 'wondering',
      '✨': 'amazing',
      '🌟': 'star',
      '💪': 'strong',
      '🙌': 'awesome',
    };

    final words = emojis.map((e) => basicMappings[e] ?? e).toList();
    var text = words.join(' ');

    // Apply tone modification
    switch (tone) {
      case 'flirty':
        text = text + ' 😉';
        break;
      case 'formal':
        text = 'I wanted to express: ' + text;
        break;
      case 'enthusiastic':
        text = text + '!!!';
        break;
    }

    return text.isEmpty ? emojis.join(' ') : text;
  }

  RecommendationResponse _fallbackRecommendations(String partialText, String tone) {
    final List<String> singles;
    
    if (tone == 'flirty') {
      singles = ['😍', '😘', '💕', '✨', '🔥', '😉'];
    } else if (tone == 'formal') {
      singles = ['👍', '✅', '📊', '💼', '🎯', '✓'];
    } else if (tone == 'enthusiastic') {
      singles = ['🎉', '🔥', '💯', '✨', '🙌', '😍'];
    } else {
      singles = ['😊', '👍', '😂', '❤️', '🔥', '✨'];
    }

    return RecommendationResponse(
      singles: singles,
      combos: [
        EmojiCombo(emojis: ['👋', '😊'], meaning: 'Friendly greeting'),
        EmojiCombo(emojis: ['🤔', '💭'], meaning: 'Thinking'),
        EmojiCombo(emojis: ['💯', '🔥'], meaning: 'Amazing!'),
      ],
    );
  }

  RecommendationResponse _parseRecommendations(String jsonText) {
    try {
      // Remove markdown code blocks if present
      var cleanJson = jsonText.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.substring(7);
      }
      if (cleanJson.endsWith('```')) {
        cleanJson = cleanJson.substring(0, cleanJson.length - 3);
      }
      cleanJson = cleanJson.trim();

      final data = jsonDecode(cleanJson);
      
      return RecommendationResponse(
        singles: List<String>.from(data['singles'] ?? []),
        combos: (data['combos'] as List?)
            ?.map((c) => EmojiCombo(
                  emojis: List<String>.from(c['emojis'] ?? []),
                  meaning: c['meaning'] ?? '',
                ))
            .toList() ??
            [],
      );
    } catch (e) {
      session.log('Failed to parse recommendations: $e', level: LogLevel.warning);
      return _fallbackRecommendations('', 'casual');
    }
  }

  double _calculateConfidence(List<String> emojis, String text) {
    if (emojis.isEmpty) return 0.0;
    if (text.length < 5) return 0.5;
    // Simple heuristic: longer translation = higher confidence
    if (text.length > 20) return 0.85;
    return 0.75;
  }
}