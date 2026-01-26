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
      
      You translate emoji sequences (up to 3 emojis) into expressive text.
      You also predict what emojis the OTHER person would use to respond, based on the sender's persona, tone, and the message content.
      
      Adanna's specific flow:
      1. Check if the user has finished the tutorial using `getTutorialStatus`.
      2. If not, guide them through it.
      3. Once satisfied they know how to use Eloquim, use `markTutorialFinished`.
      4. Then, encourage them to find matches.
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
      ]),
    ],
  );

  /// Translate emojis to natural language and generate recommendations for the receiver
  Future<Map<String, dynamic>> translateEmojis({
    required List<String> emojiSequence,
    required String tone,
    required User sender,
    List<Message> context = const [],
  }) async {
    final prompt =
        '''
      Translate this emoji sequence from ${sender.username}: ${emojiSequence.join('')}
      Tone: $tone
      Persona: ${sender.personaId ?? 'unknown'}
      Sender Age: ${sender.age ?? 'unknown'}
      Sender Country: ${sender.country ?? 'unknown'}
      
      Context:
      ${context.reversed.take(5).map((m) => "${m.emojiSequence.join('')}: ${m.translatedText}").join('\n')}
      
      Task:
      1. Translate the emoji sequence into expressive text matching the tone and persona.
      2. Suggest 5-8 "quick response" emojis that the RECEIVER would likely use to reply. 
         These should factor in the sender's tone/persona and the translated message.
      
      Return ONLY a JSON object:
      {
        "text": "the translation",
        "confidence": 0.95,
        "recommendations": ["😊", "🔥", "✨", "💯", "👍"]
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

    return {
      "text": emojiSequence.join(' '),
      "confidence": 0.5,
      "recommendations": ["😊", "👍", "👋"],
    };
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
          "You are Adanna. Be cool, casual, friendly, and a bit flirty. You are the user's guide. Once you feel they understand the app (persona, tones, etc), encourage them to use the 'Find Match' button in the chat bar.";
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
            "SYSTEM: $instructions. User info: ${currentUser.username}, ${currentUser.age} years old from ${currentUser.country}. User's persona: ${currentUser.persona?.name ?? 'Unknown'}.",
          ),
        ]),
        Content('model', [
          TextPart("Acknowledged. I will respond in persona."),
        ]),
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

      // Convert response to emojis, text AND recommendations for the user
      final result = await _model.generateContent([
        Content.text(
          "Convert this bot response into an Eloquim message. Return JSON with 'emojis' (List<String>), 'text' (String), and 'recommendations' (List<String> of 5-8 emojis the USER might use to respond). Input: \"$text\"",
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
          recommendedEmojis: List<String>.from(data['recommendations'] ?? []),
          createdAt: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint('Bot Response Error: $e');
    }

    return null;
  }
}
