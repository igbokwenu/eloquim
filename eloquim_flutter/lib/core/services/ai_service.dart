import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:eloquim_client/eloquim_client.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash-lite',
    systemInstruction: Content.text('''
      You are Eloquim AI, a sophisticated emoji translation and communication assistant.
      Your primary job is to translate emojis to natural language and vice versa, 
      matching the user's selected tone and persona.
      
      When acting as a bot persona (like Adanna), you embody that personality:
      - Adanna: Cool, casual, friendly, and a bit flirty. She's the user's guide.
      - Chuck: Professional, sophisticated, clear.
      - Sarah: Romantic, deep, expressive.
      - Brian: Energetic, hype, Gen Z.
      
      You have access to tools to interact with the app state.
      Always respond in the context of the current conversation.
      
      Adanna's specific flow:
      1. Check if the user has finished the tutorial using `getTutorialStatus`.
      2. If not, guide them through it.
      3. Once satisfied they know how to use Eloquim, use `markTutorialFinished`.
      4. Then, encourage them to find matches using `navigateToFindMatch`.
    '''),
    tools: [
      Tool.functionDeclarations([
        FunctionDeclaration(
          'getTutorialStatus',
          'Get the current user\'s tutorial completion status.',
          parameters: {},
        ),
        FunctionDeclaration(
          'markTutorialFinished',
          'Mark the current user\'s tutorial as completed.',
          parameters: {},
        ),
        FunctionDeclaration(
          'navigateToFindMatch',
          'Navigate the user to the Find Match screen to meet real people.',
          parameters: {
            'reason': Schema.string(
              description: 'Friendly reason for navigating',
            ),
          },
        ),
      ]),
    ],
  );

  /// Translate emojis to natural language
  Future<Map<String, dynamic>> translateEmojis({
    required List<String> emojiSequence,
    required String tone,
    required String personaId,
    List<Message> context = const [],
  }) async {
    final prompt =
        '''
      Translate this emoji sequence: ${emojiSequence.join('')}
      Tone: $tone
      Persona: $personaId
      
      Context:
      ${context.take(5).map((m) => "${m.emojiSequence.join('')}: ${m.translatedText}").join('\n')}
      
      Return ONLY a JSON object:
      {
        "text": "the translation",
        "confidence": 0.95
      }
    ''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      final jsonStart = text.indexOf('{');
      final jsonEnd = text.lastIndexOf('}') + 1;
      if (jsonStart != -1 && jsonEnd != -1) {
        final cleanJson = text.substring(jsonStart, jsonEnd);
        return jsonDecode(cleanJson);
      }
    } catch (e) {
      debugPrint('AI Translation Error: $e');
    }

    return {"text": emojiSequence.join(' '), "confidence": 0.5};
  }

  /// Get emoji recommendations based on partial text
  Future<Map<String, dynamic>> recommendEmojis({
    required String text,
    required String tone,
    required String personaId,
    List<Message> context = const [],
  }) async {
    final prompt =
        '''
      Provide emoji recommendations for this text: "$text"
      Tone: $tone
      Persona: $personaId
      
      Return JSON:
      {
        "singles": ["😊", "🔥", "✨", "💯", "👍", "😂"],
        "combos": [
          {"emojis": ["✨", "💖"], "meaning": "pure magic"},
          {"emojis": ["🔥", "💯"], "meaning": "absolutely fire"},
          {"emojis": ["🤔", "💭"], "meaning": "deep thoughts"}
        ]
      }
    ''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final respText = response.text ?? '';
      final jsonStart = respText.indexOf('{');
      final jsonEnd = respText.lastIndexOf('}') + 1;
      if (jsonStart != -1 && jsonEnd != -1) {
        return jsonDecode(respText.substring(jsonStart, jsonEnd));
      }
    } catch (e) {
      debugPrint('AI Recommendation Error: $e');
    }

    return {
      "singles": ["😊", "👍", "🔥"],
      "combos": [],
    };
  }

  /// Generate a response as a specific Bot persona with tool calling
  Future<Message?> generateBotResponse({
    required User botUser,
    required List<Message> history,
    required User currentUser,
    required Future<Map<String, dynamic>> Function(
      String toolName,
      Map<String, dynamic> args,
    )
    onToolCall,
  }) async {
    String instructions = "";
    if (botUser.username.toLowerCase().contains('adanna')) {
      instructions =
          "You are Adanna. Be cool, casual, friendly, and a bit flirty. You are the user's guide. Once you feel they understand the app, suggest they 'Find Match' using the tool.";
    } else if (botUser.username.toLowerCase().contains('chuck')) {
      instructions =
          "You are Chuck. Be professional, sophisticated, and clear.";
    } else if (botUser.username.toLowerCase().contains('sarah')) {
      instructions = "You are Sarah. Be deep, romantic, and expressive.";
    } else if (botUser.username.toLowerCase().contains('brian')) {
      instructions = "You are Brian. Be energetic, hype, and use Gen Z slang.";
    }

    final chatHistory = history.map((m) {
      final isBot = m.senderId == botUser.id;
      return Content(
        isBot ? 'model' : 'user',
        [TextPart(m.translatedText)],
      );
    }).toList();

    final chat = _model.startChat(
      history: [
        Content('user', [
          TextPart(
            "SYSTEM: $instructions. User's persona: ${currentUser.persona?.name ?? 'Unknown'}. User's name: ${currentUser.username}",
          ),
        ]),
        Content('model', [TextPart("Acknowledged.")]),
        ...chatHistory,
      ],
    );

    try {
      var response = await chat.sendMessage(
        Content.text(
          "Respond to the user. Embody your persona. Use tools if appropriate.",
        ),
      );

      // Handle tool calls
      while (response.functionCalls.isNotEmpty) {
        final List<FunctionResponse> functionResponses = [];

        for (final call in response.functionCalls) {
          final result = await onToolCall(call.name, call.args);
          functionResponses.add(FunctionResponse(call.name, result));
        }

        response = await chat.sendMessage(
          Content.functionResponses(functionResponses),
        );
      }

      final text = response.text ?? '';

      // Convert response to emojis and text
      final result = await _model.generateContent([
        Content.text(
          "Convert this text into an Eloquim message (Emojis + Translation). Return JSON with 'emojis' (List<String>) and 'text' (String). Input: \"$text\"",
        ),
      ]);

      final parsedText = result.text ?? '';
      final jsonStart = parsedText.indexOf('{');
      final jsonEnd = parsedText.lastIndexOf('}') + 1;

      if (jsonStart != -1 && jsonEnd != -1) {
        final data = jsonDecode(parsedText.substring(jsonStart, jsonEnd));
        return Message(
          conversationId: history.isNotEmpty ? history.last.conversationId : 0,
          senderId: botUser.id!,
          emojiSequence: List<String>.from(data['emojis'] ?? []),
          translatedText: data['text'] ?? '',
          tone: 'casual',
          personaUsed: botUser.personaId?.toString() ?? 'bot',
          confidenceScore: 1.0,
          createdAt: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint('Bot Response Error: $e');
    }

    return null;
  }
}
