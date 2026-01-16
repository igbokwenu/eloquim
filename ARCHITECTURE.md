# Eloquim: Architectural Blueprint & V1 Specification

## Core Vision

Eloquim transforms emoji into expressive, personality-driven communication through AI-powered translation, creating a universal language that bridges hearts and minds through modern hieroglyphics.

---

## 1. The Eloquim Protocol (EMP v1.0)

### Message Format Specification

```json
{
  "protocol": "eloquim.v1",
  "msg_id": "uuid-v4",
  "conversation_id": "conv_abc123",
  "sender": {
    "id": "user_123",
    "persona_id": "gen_z_v1",
    "emoji_signature": "✨🎵💫"
  },
  "content": {
    "emoji_sequence": ["👋", "😊", "🔥"],
    "raw_intent": "Hey! Great to see you!",
    "translated_text": "Hey there! So excited to connect!",
    "tone": "casual_enthusiastic",
    "confidence_score": 0.92
  },
  "context": {
    "reply_to_msg_id": "msg_122",
    "conversation_mood_score": 0.7,
    "media": {
      "gif_id": "tenor_xyz789",
      "gif_url": "https://..."
    }
  },
  "metadata": {
    "timestamp": "2026-01-13T12:00:00Z",
    "delivered": false,
    "read": false,
    "encrypted": false
  },
  "signature": "base64_signature_here"
}
```

### Protocol Design Principles

- **Versioned**: Protocol version in every message for backward compatibility
- **Self-contained**: Each message carries full context for translation
- **Extensible**: JSON structure allows new fields without breaking changes
- **Verifiable**: Optional signature for third-party app integration
- **Privacy-aware**: Supports E2E encryption mode (encrypted payload only)

---

## 2. System Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    ELOQUIM ECOSYSTEM                         │
└─────────────────────────────────────────────────────────────┘

┌───────────────────── FLUTTER CLIENT ─────────────────────────┐
│                                                               │
│  ┌────────────── PRESENTATION LAYER ──────────────┐         │
│  │  • Onboarding Flow    • Chat Interface         │         │
│  │  • Persona Setup      • Profile Management     │         │
│  │  • Tutorial (Lucy)    • Settings               │         │
│  └────────────────────────────────────────────────┘         │
│                         ▼                                     │
│  ┌────────────── STATE MANAGEMENT ─────────────────┐        │
│  │              Riverpod 3.x Providers              │        │
│  │                                                  │        │
│  │  ChatNotifier         → Active chat state       │        │
│  │  PersonaNotifier      → User persona profile    │        │
│  │  AIServiceNotifier    → AI interaction state    │        │
│  │  RecommendationNotifier → Emoji suggestions    │        │
│  │  PresenceNotifier     → Typing/online status    │        │
│  └──────────────────────────────────────────────────┘        │
│                         ▼                                     │
│  ┌────────────── DYNAMIC UI LAYER ────────────────┐         │
│  │           GenUI 0.6.x + Firebase AI             │         │
│  │                                                  │         │
│  │  • Emotion-responsive chat bubbles              │         │
│  │  • Tone-morphing animations                     │         │
│  │  • Live translation preview                     │         │
│  │  • Adaptive suggestion UI                       │         │
│  └──────────────────────────────────────────────────┘        │
└───────────────────────────────────────────────────────────────┘
                             ▼
┌──────────────────── SERVERPOD 3.x BACKEND ───────────────────┐
│                                                               │
│  ┌───────────────── API ENDPOINTS ─────────────────┐        │
│  │  ChatEndpoint          → Send/stream messages   │        │
│  │  PersonaEndpoint       → CRUD personas          │        │
│  │  MatchingEndpoint      → Find compatible users  │        │
│  │  RecommendationEndpoint → Get emoji suggestions │        │
│  │  PresenceEndpoint      → Update/track presence  │        │
│  └──────────────────────────────────────────────────┘        │
│                         ▼                                     │
│  ┌───────────── BUSINESS LOGIC LAYER ──────────────┐        │
│  │  TranslationService    → Emoji ↔ Text          │        │
│  │  PersonaMatchingEngine → Compatibility scoring  │        │
│  │  ConversationManager   → Context management     │        │
│  │  RecommendationEngine  → Smart suggestions      │        │
│  │  VibeAnalysisService   → Mood tracking          │        │
│  └──────────────────────────────────────────────────┘        │
│                         ▼                                     │
│  ┌────────── REAL-TIME COMMUNICATION ──────────────┐        │
│  │  WebSocket Manager     → Live messaging         │        │
│  │  Presence System       → Online/typing status   │        │
│  │  Message Queue         → Delivery guarantee     │        │
│  └──────────────────────────────────────────────────┘        │
└───────────────────────────────────────────────────────────────┘
                             ▼
┌───────────────────── AI SERVICES LAYER ──────────────────────┐
│                                                               │
│  ┌──────────── FIREBASE AI (Gemini) ───────────────┐        │
│  │                                                  │        │
│  │  TranslationAgent                                │        │
│  │  ├─ Input: emoji_sequence + persona + context   │        │
│  │  └─ Output: natural_language + confidence        │        │
│  │                                                  │        │
│  │  PersonaAnalysisAgent                            │        │
│  │  ├─ Input: user_responses + chat_history        │        │
│  │  └─ Output: persona_vector + communication_style │        │
│  │                                                  │        │
│  │  RecommendationAgent                             │        │
│  │  ├─ Input: conversation_context + user_patterns │        │
│  │  └─ Output: suggested_emojis + combos + GIFs    │        │
│  │                                                  │        │
│  │  VibeMatchingAgent                               │        │
│  │  ├─ Input: user_profiles + interaction_patterns │        │
│  │  └─ Output: compatibility_scores + reasons      │        │
│  │                                                  │        │
│  │  TutorialAgent (Lucy)                            │        │
│  │  ├─ Input: user_progress + interaction_context  │        │
│  │  └─ Output: guided_prompts + examples            │        │
│  └──────────────────────────────────────────────────┘        │
│                         ▼                                     │
│  ┌────────────── TOOL FUNCTIONS ──────────────────┐         │
│  │  • fetch_gif_recommendations()                  │         │
│  │  • analyze_sentiment()                          │         │
│  │  • generate_emoji_suggestions()                 │         │
│  │  • calculate_chemistry_score()                  │         │
│  │  • create_conversation_artifact()               │         │
│  └──────────────────────────────────────────────────┘        │
└───────────────────────────────────────────────────────────────┘
                             ▼
┌──────────────────── DATA & STORAGE ──────────────────────────┐
│                                                               │
│  ┌─────────── FIREBASE SERVICES ────────────┐               │
│  │  • Authentication (Google, Anonymous)     │               │
│  │  • Cloud Storage (Artifacts, Media)       │               │
│  │  • Firebase AI (Gemini Integration)       │               │
│  └───────────────────────────────────────────┘               │
│                         ▼                                     │
│  ┌──────────── POSTGRESQL (Serverpod) ──────┐               │
│  │  Core Tables:                             │               │
│  │  • users                                  │               │
│  │  • personas                               │               │
│  │  • conversations                          │               │
│  │  • messages                               │               │
│  │  • emoji_mappings                         │               │
│  │  • conversation_artifacts                 │               │
│  │  • user_preferences                       │               │
│  └───────────────────────────────────────────┘               │
│                         ▼                                     │
│  ┌────────────── REDIS CACHE ───────────────┐               │
│  │  • Active user presence                   │               │
│  │  • Typing indicators (TTL: 5s)            │               │
│  │  • Recent suggestions (TTL: 1h)           │               │
│  │  • Conversation context (last 20 msgs)    │               │
│  └───────────────────────────────────────────┘               │
└───────────────────────────────────────────────────────────────┘
                             ▼
┌────────────────── EXTERNAL SERVICES ─────────────────────────┐
│  • Tenor/Giphy GIF API                                       │
│  • Analytics & Monitoring (Firebase Analytics)               │
│  • Content Moderation API                                    │
└───────────────────────────────────────────────────────────────┘
```

---

## 3. Database Schema

### Core Tables (PostgreSQL)

```yaml
# users.yaml
class: User
table: users
fields:
  id: int, primary
  username: String
  email: String?, index
  gender: String?
  age: int?
  country: String?
  persona_id: int?, relation(Persona)
  emoji_signature: String  # "✨🎵💫"
  has_done_tutorial: bool, default=false
  created_at: DateTime, default=now
  last_seen: DateTime
  is_anonymous: bool, default=true

# personas.yaml
class: Persona
table: personas
fields:
  id: int, primary
  name: String  # "Gen Z", "Stoic Sage", "Romance Novelist"
  creator_id: int?, relation(User)
  is_official: bool, default=false
  description: String
  traits_json: String  # JSON: {"openness": 0.8, "humor": 0.6}
  communication_style: String  # "casual", "formal", "poetic"
  emoji_mappings: List<EmojiMapping>
  pack_version: String, default="1.0"
  created_at: DateTime, default=now

# conversations.yaml
class: Conversation
table: conversations
fields:
  id: int, primary
  type: String  # "p2p", "group", "ai_tutorial"
  title: String?
  participant_ids: List<int>
  started_at: DateTime, default=now
  last_message_at: DateTime
  chemistry_score: double?  # 0.0-1.0
  status: String, default="active"  # "active", "archived", "blocked"

# messages.yaml
class: Message
table: messages
fields:
  id: int, primary
  conversation_id: int, relation(Conversation)
  sender_id: int, relation(User)
  emoji_sequence: List<String>  # ["👋", "😊", "🔥"]
  raw_intent: String?
  translated_text: String
  tone: String  # "casual", "flirty", "formal", etc.
  persona_used: String
  confidence_score: double
  media_gif_url: String?
  reply_to_msg_id: int?
  created_at: DateTime, default=now
  delivered_at: DateTime?
  read_at: DateTime?
  is_encrypted: bool, default=false

# emoji_mappings.yaml
class: EmojiMapping
table: emoji_mappings
fields:
  id: int, primary
  persona_id: int, relation(Persona)
  emoji_sequence: String  # "👋😊" (concatenated)
  canonical_text: String  # "friendly greeting"
  context_tags: List<String>  # ["greeting", "casual"]
  usage_count: int, default=0
  created_at: DateTime, default=now

# conversation_artifacts.yaml
class: ConversationArtifact
table: conversation_artifacts
fields:
  id: int, primary
  conversation_id: int, relation(Conversation)
  type: String  # "memory_crystal", "emoji_constellation", "vibe_map"
  content_json: String  # Serialized artifact data
  created_at: DateTime, default=now

# user_preferences.yaml
class: UserPreference
table: user_preferences
fields:
  id: int, primary
  user_id: int, relation(User)
  key: String  # "default_tone", "emoji_preview_enabled"
  value: String
  updated_at: DateTime, default=now
```

### Indexes for Performance

```sql
CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at DESC);
CREATE INDEX idx_messages_sender ON messages(sender_id, created_at DESC);
CREATE INDEX idx_conversations_participant ON conversations USING GIN(participant_ids);
CREATE INDEX idx_emoji_mappings_persona ON emoji_mappings(persona_id, emoji_sequence);
CREATE INDEX idx_users_last_seen ON users(last_seen DESC) WHERE is_anonymous = false;
```

---

## 4. Core Technical Flows

### Flow 1: Message Send & Translation

```
User composes message
       ↓
[ChatNotifier] captures intent + selected tone
       ↓
Local State Update (optimistic UI)
       ↓
[AIServiceNotifier] calls TranslationAgent
       ├─ Input: raw_intent, tone, persona, last 6 messages
       └─ Output: emoji_sequence, translated_text, confidence
       ↓
[ChatNotifier] updates with AI response
       ↓
[Serverpod Client] sends EMP message
       ↓
[ChatEndpoint] receives message
       ├─ Validates auth
       ├─ Saves to PostgreSQL
       ├─ Broadcasts via WebSocket to recipient(s)
       └─ Triggers async recommendation generation
       ↓
Recipient receives message
       ↓
[GenUI] renders dynamic bubble based on tone
```

### Flow 2: Real-time Emoji Suggestions

```
User starts typing in composer
       ↓
[RecommendationNotifier] debounces input (300ms)
       ↓
Calls local micro-model (if available) for instant suggestions
       ↓
Parallel call to cloud RecommendationAgent
       ├─ Input: partial_text, conversation_context, user_patterns
       └─ Output: top 6 single emojis, 3 combo suggestions
       ↓
[RecommendationNotifier] merges local + cloud results
       ↓
UI displays suggestions with smooth animation
       ↓
User taps suggestion
       ↓
Track acceptance for adaptive learning (contextual bandit)
```

### Flow 3: Presence & Typing Indicators

```
User enters chat screen
       ↓
[PresenceNotifier] calls PresenceEndpoint.updateStatus("online")
       ↓
[Serverpod] writes to Redis: "user:{id}:status" = "online" (TTL: 60s)
       ↓
[Serverpod] broadcasts presence to conversation participants
       ↓
Recipients see "online" indicator
       ↓
User starts typing
       ↓
[ChatNotifier] throttles typing events (1 per second)
       ↓
[Serverpod] broadcasts "typing" event via WebSocket
       ↓
[Redis] sets "user:{id}:typing:{conv_id}" = true (TTL: 5s)
       ↓
Recipients see typing indicator
       ↓
User stops typing (5s timeout)
       ↓
Typing indicator auto-disappears
```

---

## 5. Key Code Snippets

### Serverpod Endpoint (Backend)

```dart
// lib/src/endpoints/chat_endpoint.dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ChatEndpoint extends Endpoint {

  /// Send a message (with emoji → text translation)
  Future<Message> sendMessage(
    Session session,
    SendMessageRequest request,
  ) async {
    // 1. Authenticate
    final userId = await session.authenticated?.userId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // 2. Call AI translation service
    final translation = await _translateEmoji(
      request.emojiSequence,
      request.tone,
      request.personaId,
      request.conversationId,
    );

    // 3. Create message
    final message = Message(
      conversationId: request.conversationId,
      senderId: userId,
      emojiSequence: request.emojiSequence,
      rawIntent: request.rawIntent,
      translatedText: translation.text,
      tone: request.tone,
      personaUsed: request.personaId,
      confidenceScore: translation.confidence,
      createdAt: DateTime.now(),
    );

    // 4. Persist to database
    await Message.db.insertRow(session, message);

    // 5. Broadcast to conversation participants via WebSocket
    await session.messages.postMessage(
      'chat_${request.conversationId}',
      message,
    );

    // 6. Update conversation timestamp
    await _updateConversationTimestamp(session, request.conversationId);

    // 7. Trigger async recommendation generation
    unawaited(_generateRecommendations(session, request.conversationId));

    return message;
  }

  /// Stream messages for real-time chat
  Stream<Message> streamChat(Session session, int conversationId) async* {
    // Verify user is participant
    await _verifyParticipant(session, conversationId);

    // Create WebSocket stream
    final stream = session.messages.createStream<Message>(
      'chat_$conversationId',
    );

    await for (final message in stream) {
      yield message;
    }
  }

  /// Get recent messages (for initial load)
  Future<List<Message>> getMessages(
    Session session,
    int conversationId, {
    int limit = 50,
    DateTime? before,
  }) async {
    await _verifyParticipant(session, conversationId);

    return await Message.db.find(
      session,
      where: (t) => t.conversationId.equals(conversationId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: limit,
    );
  }

  // Helper methods
  Future<TranslationResult> _translateEmoji(
    List<String> emojis,
    String tone,
    String personaId,
    int conversationId,
  ) async {
    // Call Firebase AI service
    // Implementation depends on genui_firebase_ai integration
    // Returns translated text + confidence score
  }
}
```

### Riverpod 3.x State Management (Client)

```dart
// lib/providers/chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';

/// Chat state model
class ChatState {
  final List<Message> messages;
  final bool isLoading;
  final bool isTyping;
  final String currentTone;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isTyping = false,
    this.currentTone = 'casual',
    this.error,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    bool? isTyping,
    String? currentTone,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isTyping: isTyping ?? this.isTyping,
      currentTone: currentTone ?? this.currentTone,
      error: error ?? this.error,
    );
  }
}

/// Chat notifier (Riverpod 3.x)
class ChatNotifier extends AutoDisposeAsyncNotifier<ChatState> {
  late final Client _client;
  late final int _conversationId;
  StreamSubscription? _messageSubscription;

  @override
  Future<ChatState> build() async {
    _client = ref.read(serverpodClientProvider);
    _conversationId = ref.read(currentConversationIdProvider);

    // Load initial messages
    final messages = await _client.chat.getMessages(_conversationId);

    // Subscribe to real-time updates
    _subscribeToMessages();

    // Cleanup on dispose
    ref.onDispose(() {
      _messageSubscription?.cancel();
    });

    return ChatState(messages: messages);
  }

  /// Send a message with emoji translation
  Future<void> sendMessage(String rawIntent, List<String>? emojiOverride) async {
    final currentState = state.valueOrNull ?? const ChatState();

    // Optimistic UI update
    final tempMessage = Message(
      id: -1,  // Temporary ID
      conversationId: _conversationId,
      senderId: ref.read(currentUserProvider).id,
      rawIntent: rawIntent,
      emojiSequence: emojiOverride ?? [],
      translatedText: rawIntent,
      tone: currentState.currentTone,
      createdAt: DateTime.now(),
    );

    state = AsyncData(currentState.copyWith(
      messages: [...currentState.messages, tempMessage],
    ));

    try {
      // Send to server
      final sentMessage = await _client.chat.sendMessage(
        SendMessageRequest(
          conversationId: _conversationId,
          rawIntent: rawIntent,
          emojiSequence: emojiOverride ?? [],
          tone: currentState.currentTone,
          personaId: ref.read(currentUserProvider).personaId ?? 'default',
        ),
      );

      // Replace temp message with server response
      state = AsyncData(currentState.copyWith(
        messages: [
          ...currentState.messages.where((m) => m.id != -1),
          sentMessage,
        ],
      ));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// Switch tone (for tone-morphing preview)
  void switchTone(String newTone) {
    final currentState = state.valueOrNull ?? const ChatState();
    state = AsyncData(currentState.copyWith(currentTone: newTone));
  }

  /// Subscribe to real-time messages
  void _subscribeToMessages() {
    _messageSubscription = _client.chat
        .streamChat(_conversationId)
        .listen((message) {
      final currentState = state.valueOrNull ?? const ChatState();

      // Avoid duplicates
      if (!currentState.messages.any((m) => m.id == message.id)) {
        state = AsyncData(currentState.copyWith(
          messages: [...currentState.messages, message],
        ));
      }
    });
  }
}

/// Provider
final chatProvider = AutoDisposeAsyncNotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
```

### GenUI Dynamic Bubble Component

```dart
// lib/widgets/dynamic_chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class DynamicChatBubble extends StatelessWidget {
  final Message message;
  final bool isMine;

  const DynamicChatBubble({
    required this.message,
    required this.isMine,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GenUiBuilder(
      prompt: _buildPrompt(),
      builder: (context, generatedWidget) {
        // Fallback if GenUI fails
        if (generatedWidget == null) {
          return _buildFallbackBubble();
        }

        return GestureDetector(
          onLongPress: () => _showTranslationOverlay(context),
          child: generatedWidget,
        );
      },
    );
  }

  String _buildPrompt() {
    return '''
Create a chat message bubble with these properties:
- Tone: ${message.tone}
- Emoji sequence: ${message.emojiSequence.join(' ')}
- Translated text: ${message.translatedText}
- Is sender: $isMine

Style guidelines:
- For 'flirty' tone: use soft pink gradients, rounded corners (30px), subtle pulse animation
- For 'cold' tone: use icy blue-grey, sharp corners (8px), no animation
- For 'enthusiastic' tone: use vibrant colors, bouncy animation, glow effect
- For 'formal' tone: use neutral grays, minimal corners (4px), solid background

Layout:
- Emoji sequence at top (font size 28)
- Translated text below (font size 16)
- Small confidence indicator badge (${message.confidenceScore.toStringAsFixed(2)})
- Align ${isMine ? 'right' : 'left'}

Return a Container with proper padding, decoration, and Text widgets.
''';
  }

  Widget _buildFallbackBubble() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isMine ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.emojiSequence.join(' '),
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(height: 4),
          Text(
            message.translatedText,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showTranslationOverlay(BuildContext context) {
    // "Ghost translation" feature - show raw intent on long press
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Translation Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emojis: ${message.emojiSequence.join(' ')}'),
            SizedBox(height: 8),
            Text('Raw Intent: ${message.rawIntent ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Translated: ${message.translatedText}'),
            SizedBox(height: 8),
            Text('Tone: ${message.tone}'),
            SizedBox(height: 8),
            Text('Confidence: ${(message.confidenceScore * 100).toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
```

### AI Translation Service Integration

```dart
// lib/services/ai_translation_service.dart
import 'package:genui_firebase_ai/genui_firebase_ai.dart';

class AITranslationService {
  final FirebaseVertexAI _vertexAI;

  AITranslationService(this._vertexAI);

  /// Translate emojis to text using Gemini
  Future<TranslationResult> translateEmojis({
    required List<String> emojiSequence,
    required String tone,
    required String personaId,
    required List<Message> conversationContext,
  }) async {
    final contextText = conversationContext
        .take(6)  // Last 6 messages
        .map((m) => '${m.emojiSequence.join('')}: ${m.translatedText}')
        .join('\n');

    final prompt = '''
You are Eloquim, an AI that translates emoji sequences into natural language.

Persona: $personaId
Tone: $tone
Conversation context:
$contextText

Current emoji sequence: ${emojiSequence.join(' ')}

Translate this emoji sequence into natural language that:
1. Matches the specified tone and persona
2. Considers the conversation context
3. Captures the emotional intent behind the emojis
4. Sounds natural and authentic

Return ONLY the translated text, nothing else.
''';

    final response = await _vertexAI.generateContent(prompt);
    final translatedText = response.text ?? emojiSequence.join(' ');

    // Calculate confidence (simplified)
    final confidence = _calculateConfidence(emojiSequence, translatedText);

    return TranslationResult(
      text: translatedText,
      confidence: confidence,
    );
  }

  /// Generate emoji recommendations
  Future<RecommendationResult> recommendEmojis({
    required String partialText,
    required String tone,
    required String personaId,
    required List<Message> conversationContext,
  }) async {
    final contextText = conversationContext
        .take(6)
        .map((m) => '${m.emojiSequence.join('')}: ${m.translatedText}')
        .join('\n');

    final prompt = '''
You are Eloquim's suggestion engine.

Persona: $personaId
Tone: $tone
Conversation context:
$contextText

User is typing: "$partialText"

Suggest:
1. 6 single emojis that would fit naturally
2. 3 emoji combinations (2-3 emojis each) that express complex emotions

Format as JSON:
{
  "singles": ["emoji1", "emoji2", ...],
  "combos": [
    {"emojis": ["emoji1", "emoji2"], "meaning": "short description"},
    ...
  ]
}
''';

    final response = await _vertexAI.generateContent(prompt);
    // Parse JSON response
    return _parseRecommendations(response.text ?? '{}');
  }

  double _calculateConfidence(List<String> emojis, String text) {
    // Simplified confidence calculation
    // In production, use ML model output
    if (emojis.isEmpty) return 0.0;
    if (text.length < 5) return 0.5;
    return 0.85;  // Placeholder
  }

  RecommendationResult _parseRecommendations(String jsonText) {
    // Parse JSON and return structured recommendations
    // Implementation depends on response format
  }
}

class TranslationResult {
  final String text;
  final double confidence;

  const TranslationResult({
    required this.text,
    required this.confidence,
  });
}
class RecommendationResult {
final List<String> singles;
  final List<EmojiCombo> combos;

  const RecommendationResult({
    required this.singles,
    required this.combos,
  });
}

class EmojiCombo {
  final List<String> emojis;
  final String meaning;

  const EmojiCombo({
    required this.emojis,
    required this.meaning,
  });
}
```

---

## 6. V1 Feature List & UI/UX Flow

### **Core Features for V1 (2-Week MVP)**

#### 1. **User Onboarding** ✨

- **Screens**:
  - Welcome screen with animated emoji introduction
  - Anonymous sign-in (primary) + Google OAuth (optional)
  - 5-question personality quiz to determine persona
  - Tutorial with "Lucy" AI agent (interactive chat demo)
- **Flow**:
  ```
  Welcome → Auth → Quiz (5Q) → Persona Assignment → Lucy Tutorial (3 examples) → Main Chat
  ```

#### 2. **Core Messaging** 💬

- **Features**:
  - Emoji-first composer (emoji keyboard prominent)
  - Real-time emoji → text translation preview
  - Tone selector (5 tones: Casual, Flirty, Formal, Enthusiastic, Cold)
  - Send button with haptic feedback
  - Dynamic chat bubbles (GenUI-powered)
  - Typing indicators
  - Online/offline presence
- **UI Components**:
  - Emoji composer bar (bottom)
  - Tone selector strip (above keyboard)
  - Chat bubble list (scrollable)
  - Translation confidence badge (subtle)

#### 3. **Smart Suggestions** 🤖

- **Features**:
  - Real-time emoji recommendations (6 singles)
  - Combo suggestions (3 multi-emoji)
  - Context-aware (based on conversation)
  - Tap to insert suggestion
- **UI**:
  - Suggestion bar above keyboard
  - Smooth animation on update
  - Visual highlight on tap

#### 4. **Persona System** 🎭

- **V1 Personas** (3 official packs):
  - Gen Z (casual, playful, meme-fluent)
  - Professional (formal, clear, respectful)
  - Romantic (poetic, emotional, expressive)
- **Features**:
  - Persona profile page
  - Switch persona (requires re-quiz)
  - Emoji signature display

#### 5. **Ghost Translation** 👻 _(Wow Factor)_

- **Feature**:
  - Long-press any message bubble
  - Bubble "opens" to reveal:
    - Raw emoji sequence
    - Original intent (if available)
    - Translated text
    - Confidence score
    - Tone used
- **Animation**:
  - Smooth expand/collapse
  - Semi-transparent overlay

#### 6. **Tone Morphing Preview** 🎨 _(Wow Factor)_

- **Feature**:
  - Type text or select emojis
  - Swipe tone selector
  - Watch emojis morph in real-time
  - See preview of translated text for each tone
- **UI**:
  - Horizontal tone slider
  - Live emoji animation during swipe
  - Preview text below composer

#### 7. **Conversation List** 📋

- **Features**:
  - List of active conversations
  - Last message preview (emoji + text)
  - Unread count badge
  - Online status indicator
  - Swipe actions (archive, delete)

#### 8. **Basic Profile** 👤

- **Features**:
  - Username
  - Emoji signature (auto-generated)
  - Current persona
  - Join date
  - Edit profile (username only in V1)

#### 9. **Simple Matchmaking** 🔗

- **Features**:
  - "Find New Connection" button
  - Match based on persona compatibility
  - Age/country filters (optional)
  - Accept/Skip interface
- **Flow**:
  ```
  Tap "Find Match" → Server finds compatible user →
  Show profile card → Accept → Start conversation
  ```

#### 10. **Settings** ⚙️

- **Options**:
  - Default tone preference
  - Enable/disable suggestions
  - Enable/disable ghost translation
  - Tutorial replay
  - Logout
  - Delete account

---

### **UI/UX Flow Diagram (V1)**

```
┌─────────────────────────────────────────────────────────┐
│                   ELOQUIM V1 USER FLOW                  │
└─────────────────────────────────────────────────────────┘

[App Launch]
     ↓
┌─────────────────┐
│  Welcome Screen │ → Animated emoji intro (3s)
└─────────────────┘
     ↓
┌─────────────────┐
│   Auth Screen   │ → "Continue Anonymously" (primary)
└─────────────────┘    "Sign in with Google" (secondary)
     ↓
┌─────────────────┐
│ Personality Quiz│ → 5 questions with emoji responses
└─────────────────┘    Example: "Pick your vibe: 🎉 or 📚"
     ↓
┌─────────────────┐
│ Persona Assigned│ → "You're a Gen Z communicator! ✨"
└─────────────────┘    Shows emoji signature
     ↓
┌─────────────────┐
│ Lucy Tutorial   │ → 3 interactive examples:
└─────────────────┘    1. "Try saying hello with 👋😊"
     │                 2. "Now add tone: switch to Flirty"
     │                 3. "Long-press to see translation"
     ↓
┌─────────────────────────────────────────────────────────┐
│                     MAIN APP                             │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────────────────────────────────────┐        │
│  │       Conversation List Screen              │        │
│  │  ┌──────────────────────────────────────┐  │        │
│  │  │ [+] Find New Match         Settings   │  │        │
│  │  └──────────────────────────────────────┘  │        │
│  │                                             │        │
│  │  ┌──────────────────────────────────────┐  │        │
│  │  │ 🟢 Alex • 2m ago                     │  │        │
│  │  │ 🔥😉 "That was hot..."              │  │        │
│  │  └──────────────────────────────────────┘  │        │
│  │                                             │        │
│  │  ┌──────────────────────────────────────┐  │        │
│  │  │ ⚪ Jamie • 1h ago                    │  │        │
│  │  │ 💤😴 "Goodnight!"                   │  │        │
│  │  └──────────────────────────────────────┘  │        │
│  └────────────────────────────────────────────┘        │
│       ↓ Tap conversation                               │
│  ┌────────────────────────────────────────────┐        │
│  │          Chat Screen                        │        │
│  │  ┌──────────────────────────────────────┐  │        │
│  │  │ < Back    Alex 🟢        [Profile]   │  │        │
│  │  └──────────────────────────────────────┘  │        │
│  │                                             │        │
│  │  [Chat bubbles scroll area]                │        │
│  │                                             │        │
│  │  ┌──────────────────────────────────────┐  │ ← Other
│  │  │ 👋😊                                 │  │
│  │  │ "Hey! Great to see you!"             │  │
│  │  │ 92% confidence                       │  │
│  │  └──────────────────────────────────────┘  │
│  │                                             │        │
│  │            ┌──────────────────────────┐    │ ← Mine
│  │            │ 🔥💯                    │    │
│  │            │ "Absolutely fire!"       │    │
│  │            │ 88% confidence           │    │
│  │            └──────────────────────────┘    │
│  │                                             │        │
│  │  [Alex is typing... ]                      │        │
│  │                                             │        │
│  │  ┌──────────────────────────────────────┐  │        │
│  │  │ Suggestions:                          │  │        │
│  │  │ 😂 🎉 💯 🔥 👀 ✨                   │  │        │
│  │  │                                       │  │        │
│  │  │ Combos:                               │  │        │
│  │  │ 🤔💭 "Thinking..."                  │  │        │
│  │  │ 😍✨ "Love it!"                     │  │        │
│  │  └──────────────────────────────────────┘  │        │
│  │                                             │        │
│  │  ┌──────────────────────────────────────┐  │        │
│  │  │ Tone: [Casual] [Flirty] [Formal]     │  │        │
│  │  │       ▼                               │  │        │
│  │  └──────────────────────────────────────┘  │        │
│  │                                             │        │
│  │  ┌──────────────────────────────────────┐  │        │
│  │  │ [Emoji picker]  Type here...  [Send] │  │        │
│  │  └──────────────────────────────────────┘  │        │
│  └────────────────────────────────────────────┘        │
│                                                          │
│  ┌────────────────────────────────────────────┐        │
│  │       Find Match Screen                     │        │
│  │                                             │        │
│  │         ┌─────────────────────┐            │        │
│  │         │                     │            │        │
│  │         │    [Profile Card]   │            │        │
│  │         │                     │            │        │
│  │         │    Jamie, 24        │            │        │
│  │         │    🎭 Romantic      │            │        │
│  │         │    ✨💖🌙         │            │        │
│  │         │                     │            │        │
│  │         │  87% compatible     │            │        │
│  │         │                     │            │        │
│  │         └─────────────────────┘            │        │
│  │                                             │        │
│  │     [Skip ❌]          [Connect ✅]        │        │
│  └────────────────────────────────────────────┘        │
│                                                          │
│  ┌────────────────────────────────────────────┐        │
│  │          Profile Screen                     │        │
│  │                                             │        │
│  │         ┌─────────────────────┐            │        │
│  │         │    [Avatar Area]    │            │        │
│  │         │        ✨💫🎵       │            │        │
│  │         └─────────────────────┘            │        │
│  │                                             │        │
│  │         Username: YourName                 │        │
│  │         Persona: Gen Z ✨                  │        │
│  │         Emoji Signature: ✨💫🎵           │        │
│  │         Joined: Jan 2026                   │        │
│  │                                             │        │
│  │         [Edit Profile]                     │        │
│  │         [View Stats]                       │        │
│  └────────────────────────────────────────────┘        │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## 7. Implementation Checklist (2-Week Sprint)

### **Week 1: Foundation**

#### Days 1-2: Project Setup

- [ ] Initialize Serverpod 3.x project
- [ ] Create Flutter app with riverpod 3.x
- [ ] Setup Firebase project (Auth, AI, Storage)
- [ ] Define database schema in YAML
- [ ] Generate Serverpod models
- [ ] Setup PostgreSQL + Redis
- [ ] Configure genui packages

#### Days 3-4: Core Backend

- [ ] Implement ChatEndpoint (send, stream, get)
- [ ] Implement AuthEndpoint (Firebase token validation)
- [ ] Implement PresenceEndpoint (Redis-backed)
- [ ] Setup WebSocket pub/sub
- [ ] Create basic AI translation service integration
- [ ] Test endpoints with Postman/Insomnia

#### Days 5-7: Basic UI

- [ ] Create welcome screen
- [ ] Implement auth flow (anonymous + Google)
- [ ] Build personality quiz (5 questions)
- [ ] Create persona assignment screen
- [ ] Implement conversation list screen
- [ ] Build basic chat screen (no AI yet)
- [ ] Setup Riverpod providers structure

### **Week 2: AI & Polish**

#### Days 8-10: AI Integration

- [ ] Integrate genui_firebase_ai
- [ ] Implement emoji → text translation
- [ ] Build recommendation engine
- [ ] Create Lucy tutorial agent
- [ ] Wire up AI to chat UI
- [ ] Add confidence scores

#### Days 11-12: Wow Features

- [ ] Implement GenUI dynamic bubbles
- [ ] Add ghost translation (long-press)
- [ ] Build tone morphing preview
- [ ] Add emoji suggestion bar
- [ ] Implement typing indicators
- [ ] Add presence indicators

#### Days 13-14: Final Polish

- [ ] Implement matchmaking flow
- [ ] Create profile screen
- [ ] Add settings screen
- [ ] Performance optimization
- [ ] Error handling
- [ ] Basic analytics
- [ ] Testing & bug fixes
- [ ] Deploy to staging

---

## 8. Success Metrics for V1

### Technical Metrics

- **Message latency**: < 500ms (emoji → text translation)
- **Suggestion latency**: < 300ms (local), < 800ms (cloud)
- **Uptime**: > 99% (backend)
- **Error rate**: < 1%

### User Metrics

- **Tutorial completion**: > 70%
- **Message send rate**: > 5 messages per session
- **Suggestion acceptance**: > 30%
- **Tone switching**: > 2 switches per session
- **Ghost translation usage**: > 20% of users try it

### Engagement Metrics

- **DAU (Daily Active Users)**: Track growth
- **Session length**: > 5 minutes average
- **Return rate**: > 40% next-day return
- **Match acceptance**: > 50%

---

## 9. Future Enhancements (Post-V1)

### V1.1 Features (Weeks 3-4)

- Conversation artifacts (memory crystals)
- Emoji combinator (drag & fuse)
- GIF integration (Tenor API)
- Vibe matching algorithm
- Chemistry score visualization

### V1.5 Features (Weeks 5-8)

- Persona marketplace (community packs)
- On-device micro-model (offline suggestions)
- E2E encryption mode
- Group conversations
- Voice messages (emoji-annotated)

### V2.0 Features (Months 3-6)

- Open protocol SDK (third-party apps)
- Advanced analytics dashboard
- Gamification (badges, streaks)
- Accessibility features (TTS, haptics)
- Cross-platform desktop app

---

## Summary

This blueprint provides a **production-ready architecture** for Eloquim V1 that can be built by a high-velocity team in 2 weeks. The core differentiators are:

1. **AI-powered emoji translation** with persona awareness
2. **GenUI dynamic bubbles** that respond to emotional tone
3. **Real-time suggestions** with contextual intelligence
4. **Wow features** (ghost translation, tone morphing) that delight users
5. **Open protocol** foundation for future extensibility

The technical stack (Serverpod 3.x + Riverpod 3.x + GenUI + Firebase AI) is modern, scalable, and well-suited for rapid iteration. The V1 feature set is ambitious yet achievable, focusing on core value delivery while leaving room for future growth.
