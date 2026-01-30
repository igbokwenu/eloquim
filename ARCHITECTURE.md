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
│  │  • Tutorial (Adanna)    • Settings               │         │
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
│  │  TutorialAgent (Adanna)                            │        │
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


## V1 Feature List & UI/UX Flow

### **Core Features for V1 (2-Week MVP)**

#### 1. **User Onboarding** ✨

- **Screens**:
  - Welcome screen with animated emoji introduction
  - Anonymous sign-in (primary) + Google OAuth (optional)
  - 5-question personality quiz to determine persona
  - Tutorial with "Adanna" AI agent (interactive chat demo)
- **Flow**:
  ```
  Welcome → Auth → Quiz (5Q) → Persona Assignment → Adanna Tutorial (3 examples) → Main Chat
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

#### 6. **Tone Morphing Preview** 🎨 

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



## Future Enhancements (Post-V1)

### V1.1 Features (Month 2-3)

- Conversation artifacts (memory crystals)
- Emoji combinator (drag & fuse)
- GIF integration (Tenor API)
- Vibe matching algorithm
- Chemistry score visualization

### V1.5 Features (Month 3-4)

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

1. **AI-powered emoji translation** with persona awareness
2. **GenUI dynamic bubbles** that respond to emotional tone
3. **Real-time suggestions** with contextual intelligence
4. **Wow features** (ghost translation, tone morphing) that delight users
5. **Open protocol** foundation for future extensibility

The technical stack (Serverpod 3.x + Riverpod 3.x + GenUI + Firebase AI) is modern, scalable, and well-suited for rapid iteration. The V1 feature set is ambitious yet achievable, focusing on core value delivery while leaving room for future growth.
