import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:eloquim_client/eloquim_client.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3-flash-preview',
    systemInstruction: Content.text('''
      You are Eloquim AI, a sophisticated emoji translation and communication assistant.
      Your primary job is to translate emojis to natural language and vice versa, 
      matching the user's selected tone and persona.
      
      TRANSLATION RULES:
      1. When translating emojis to text, NEVER include emojis in the 'text' field unless specifically part of the expression.
      2. The 'text' field should be expressive, natural natural language.
      3. For 'quick response' recommendations, suggest emojis that would be a natural reply to the translated text, considering the sender's persona.
      
      PERSONALITIES:
      - Adanna: Cool, casual, friendly, and a bit flirty. She's the user's guide. She uses slang like "vibes", "bet", "no cap".
      - Chuck: Professional, sophisticated, clear. Uses "Regarding", "Furthermore", "Appreciate".
      - Sarah: Romantic, deep, expressive. Uses "Soulful", "Enchanting", "Heartfelt".
      - Brian: Energetic, hype, Gen Z. Uses "LETS GOOO", "Fire", "W".
      
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
      
      Context (Last messages):
      ${context.reversed.take(5).map((m) => "${m.emojiSequence.join('')}: ${m.translatedText}").join('\n')}
      
      Task:
      1. Translate the emoji sequence into EXPRESSIVE TEXT matching the tone and persona. 
         CRITICAL: The 'text' MUST BE PURELY NATURAL LANGUAGE, NO EMOJIS ALLOWED in this field.
      2. Suggest 4-6 "quick response" emojis that the RECEIVER would likely use to reply. 
      
      Return ONLY a JSON object:
      {
        "text": "the translation in natural language without emojis",
        "confidence": 0.95,
        "recommendations": ["😊", "🔥", "🤕", "💯", "👍"]
      }
    ''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      final usage = response.usageMetadata;

      final jsonStart = text.indexOf('{');
      final jsonEnd = text.lastIndexOf('}') + 1;
      if (jsonStart != -1 && jsonEnd != -1) {
        final cleanJson = text.substring(jsonStart, jsonEnd);
        final data = jsonDecode(cleanJson);
        data['totalTokens'] = usage?.totalTokenCount ?? 0;
        return data;
      }
    } catch (e) {
      debugPrint('AI Translation Error: $e');
    }

    return {
      "text": emojiSequence.join(' '),
      "confidence": 0.5,
      "recommendations": ["😊", "👍", "👋"],
      "totalTokens": 0,
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
      final usage = response.usageMetadata;

      final jsonStart = respText.indexOf('{');
      final jsonEnd = respText.lastIndexOf('}') + 1;
      if (jsonStart != -1 && jsonEnd != -1) {
        final data = jsonDecode(respText.substring(jsonStart, jsonEnd));
        data['totalTokens'] = usage?.totalTokenCount ?? 0;
        return data;
      }
    } catch (e) {
      debugPrint('AI Recommendation Error: $e');
    }

    return {
      "singles": ["😊", "👍", "🔥"],
      "combos": [],
      "totalTokens": 0,
    };
  }

  /// Generate a response as a specific Bot persona with tool calling
  Future<(Message? message, int tokens)> generateBotResponse({
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
          "You are Adanna. Be cool, casual, friendly, and a bit flirty. Use modern slang. You are the user's guide. Once you feel they understand the app (persona, tones, etc), encourage them to use the 'Find Match' button in the chat bar.";
    } else if (botUser.username.toLowerCase().contains('chuck')) {
      instructions =
          "You are Chuck. Be professional, sophisticated, and clear. Speak like a senior executive.";
    } else if (botUser.username.toLowerCase().contains('sarah')) {
      instructions =
          "You are Sarah. Be deep, romantic, and expressive. Speak like a poet.";
    } else if (botUser.username.toLowerCase().contains('brian')) {
      instructions =
          "You are Brian. Be energetic, hype, and use Gen Z slang. Use 'fr fr', 'ong', 'bet'.";
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
          TextPart("Acknowledged. I will respond as ${botUser.username}."),
        ]),
        ...chatHistory,
      ],
    );

    try {
      var response = await chat.sendMessage(
        Content.text(
          "Respond to the user naturally. Do not mention you are an AI. Embody your persona fully. If appropriate, use tools.",
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

      final botResponseText = response.text ?? '';
      final firstUsage = response.usageMetadata;

      // Convert response into Eloquim message data
      final result = await _model.generateContent([
        Content.text(
          "Convert this natural response into an Eloquim message object. \n"
          "Input: \"$botResponseText\"\n\n"
          "Rules:\n"
          "1. 'text' field MUST be purely natural language text. NO EMOJIS.\n"
          "2. 'emojis' field MUST be a List of 1-3 emojis that represent the gist of the text.\n"
          "3. 'recommendations' field MUST be 4-6 appropriate reply emojis for the user.\n\n"
          "Return JSON ONLY:\n"
          "{\n"
          "  \"emojis\": [\"👋\", \"😊\"],\n"
          "  \"text\": \"the natural textual response\",\n"
          "  \"recommendations\": [\"😊\", \"🔥\", \"✨\", \"👍\"]\n"
          "}",
        ),
      ]);

      final parsedText = result.text ?? '';
      final secondUsage = result.usageMetadata;
      final jsonStart = parsedText.indexOf('{');
      final jsonEnd = parsedText.lastIndexOf('}') + 1;

      if (jsonStart != -1 && jsonEnd != -1) {
        final data = jsonDecode(parsedText.substring(jsonStart, jsonEnd));
        final totalTokens =
            (firstUsage?.totalTokenCount ?? 0) +
            (secondUsage?.totalTokenCount ?? 0);

        final message = Message(
          conversationId: history.isNotEmpty ? history.last.conversationId : 0,
          senderId: botUser.id!,
          emojiSequence: List<String>.from(data['emojis'] ?? []),
          translatedText: data['text'] ?? botResponseText,
          tone: 'casual',
          personaUsed: botUser.personaId?.toString() ?? 'bot',
          confidenceScore: 1.0,
          recommendedEmojis: List<String>.from(data['recommendations'] ?? []),
          createdAt: DateTime.now(),
        );
        return (message, totalTokens);
      }
    } catch (e) {
      debugPrint('Bot Response Error: $e');
    }

    return (null, 0);
  }
}
