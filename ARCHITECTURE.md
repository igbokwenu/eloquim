# Eloquim: Architectural Blueprint & Current Implementation (v1.0-stable)

## Core Vision

Eloquim transforms emoji into expressive, personality-driven communication through AI-powered translation, creating a universal language that bridges hearts and minds through modern hieroglyphics.

---

## 1. The Eloquim Protocol (EMP v1.0)

### Current Message Format

The system uses Serverpod-generated models that implement the core fields of the Eloquim Protocol.

```json
{
  "id": 123,
  "conversationId": 45,
  "senderId": 67,
  "emojiSequence": ["👋", "😊"],
  "rawIntent": "Optional typed text",
  "translatedText": "Hey there! So excited to connect!",
  "tone": "casual",
  "personaUsed": "Gen Z",
  "confidenceScore": 0.95,
  "recommendedEmojis": ["😊", "✨", "👋"],
  "mediaGifUrl": null,
  "replyToMsgId": null,
  "createdAt": "2026-02-07T20:00:00Z",
  "deliveredAt": null,
  "readAt": null,
  "isEncrypted": false
}
```

---

## 2. System Architecture

### High-Level Architecture Diagram (Current)

```
┌─────────────────────────────────────────────────────────────┐
│                    ELOQUIM ECOSYSTEM                         │
└─────────────────────────────────────────────────────────────┘

┌───────────────────── FLUTTER CLIENT ─────────────────────────┐
│                                                               │
│  ┌────────────── PRESENTATION LAYER ──────────────┐         │
│  │  • Quiz & Onboarding  • Chat Interface         │         │
│  │  • Persona Setup      • Find Match (Cards)     │         │
│  │  • Tutorial (Adanna)    • Settings (Basic)       │         │
│  └────────────────────────────────────────────────┘         │
│                         ▼                                     │
│  ┌────────────── STATE MANAGEMENT ─────────────────┐        │
│  │              Riverpod Notifiers                  │        │
│  │                                                  │        │
│  │  ChatNotifier         → Active chat & sending   │        │
│  │  ConversationNotifier → Discussion list         │        │
│  │  MatchNotifier        → Potential match queue   │        │
│  │  RecommendationProv.  → Emoji suggestions       │        │
│  └──────────────────────────────────────────────────┘        │
│                         ▼                                     │
│  ┌────────────── AI INFRASTRUCTURE ────────────────┐        │
│  │           Firebase AI / Gemini 3              │        │
│  │                                                  │        │
│  │  AIService (Client-side Singleton)               │        │
│  │  • Emoji -> Text Translation                     │        │
│  │  • "Quick Response" Generation                   │        │
│  │  • Bot Persona Logic (Adanna, Sarah, etc)        │        │
│  │  • Tool calling (Tutorial/Navigation)            │        │
│  └──────────────────────────────────────────────────┘        │
└───────────────────────────────────────────────────────────────┘
                             ▼
┌──────────────────── SERVERPOD BACKEND ───────────────────────┐
│                                                               │
│  ┌───────────────── API ENDPOINTS ─────────────────┐        │
│  │  ChatEndpoint          → Message history        │        │
│  │  ConversationEndpoint   → Manage chats           │        │
│  │  UserEndpoint          → Profile & Matchmaking  │        │
│  │  PersonaEndpoint       → Official packs         │        │
│  │  RecommendationEP      → Fallback suggestions   │        │
│  └──────────────────────────────────────────────────┘        │
│                         ▼                                     │
│  ┌────────── REAL-TIME COMMUNICATION ──────────────┐        │
│  │  WebSocket Manager     → Live message stream    │        │
│  │  Auth Module           → Login / Account Mgmt   │        │
│  └──────────────────────────────────────────────────┘        │
└───────────────────────────────────────────────────────────────┘
                             ▼
┌──────────────────── DATA & STORAGE ──────────────────────────┐
│                                                               │
│  ┌──────────── POSTGRESQL (Serverpod) ──────┐               │
│  │  Core Tables:                             │               │
│  │  • users (inc. isBot, totalTokens)       │               │
│  │  • personas                               │               │
│  │  • conversations                          │               │
│  │  • messages                               │               │
│  │  • token_logs (API usage tracking)        │               │
│  └───────────────────────────────────────────┘               │
└───────────────────────────────────────────────────────────────┘
```

---

## 3. Database Schema (Current Models)

### Core Tables (PostgreSQL)

```yaml
# User
fields:
  authUserId: UuidValue?
  username: String
  email: String?
  gender: String?
  age: int?
  country: String?
  personaId: int?
  emojiSignature: String
  hasDoneTutorial: bool
  isAnonymous: bool
  isBot: bool
  totalTokenCount: int

# Message
fields:
  conversationId: int
  senderId: int
  emojiSequence: List<String>
  rawIntent: String?
  translatedText: String
  tone: String
  personaUsed: String
  confidenceScore: double
  recommendedEmojis: List<String>?
  mediaGifUrl: String?
  createdAt: DateTime

# TokenLog
fields:
  userId: int
  tokenCount: int
  estimatedCost: double
  apiCallType: String
  timestamp: DateTime
```

---

## 4. Core Technical Flows

### Flow 1: Message Send & Translation (Client-Side First)

```
User selects 1-3 emojis -> Clicks Send
       ↓
[ChatNotifier] adds optimistic message ("...")
       ↓
[AIService] calls Gemini API
       ├─ Input: emoji_sequence, tone, sender_persona, context
       └─ Output: translated_text, confidence, recommended_replies
       ↓
[Serverpod Client] calls ChatEndpoint.sendMessage()
       ├─ Saves message to DB (including AI recommendations)
       └─ Broadcasts via WebSocket
       ↓
[ChatNotifier] updates UI with confirmed message
       ↓
[AIService] checks if recipient is a Bot
       └─ If yes: Triggers Bot response flow
```

---

## 5. Current Implementation Status

### **Implemented in V1.0** ✅

#### 1. **User Onboarding** ✨

- Animated welcome screen and anonymous authentication.
- 5-question personality quiz with automatic persona calculation.
- **Interactive Tutorial**: Guided chat with "Adanna" AI bot using GenUI components (AuraAtmosphere, SoulPacketStatus).
- Profile setup (Age, Country, Gender).

#### 2. **Core Messaging** 💬

- **Emoji-first Keyboard**: Grid-based selection, strictly limited to 3 emojis per message.
- **Persona-aware Translation**: Client-side AI translates emojis into expressive text based on selected tone.
- **Tone Selector**: 5 distinct tones (Casual, Flirty, Formal, Enthusiastic, Cold) with distinct bubble styling.
- **Real-time Streaming**: WebSocket-based message delivery via Serverpod.
- **Ghost Translation**: Long-press any bubble to view raw emojis, confidence score, and tone metadata (Dialog view).

#### 3. **Smart Suggestions** 🤖

- **Next-Step recommendations**: Receiving a message automatically updates the composer's "Suggested Quick Responses" bar with 4-6 AI-recommended emojis tailored to the received content.

#### 4. **Persona System** 🎭

- 4 Official Bot Personas: Adanna (Guide), Chuck (Professional), Sarah (Romantic), Brian (Hype).
- Official Persona packs with unique traits and communication styles.

#### 5. **Matchmaking** 🔗

- Tinder-style card interface to find new connections.
- Shuffled pool of real users and AI bots to ensure activity.

#### 6. **Infrastructure** ⚙️

- **Token Tracking**: Full audit log of AI token usage and estimated costs per user.
- **Account Management**: Support for account deletion and session revocation.

---

## 6. Upcoming Features & Roadmap

### **High Priority (Next Sprint)** 🚀

- **Presence & Typing**: Implementation of typing indicators and online/offline status indicators via Redis/Serverpod.
- **Live Preview**: Real-time translation preview in the composer _while_ selecting emojis.
- **Tone Morphing Animations**: Visual "morphing" of the selected emojis when switching tones in the composer.
- **GIF Integration**: Tenor/Giphy API support for sending and rendering GIFs.

### **In Progress / Future (Post-V1)** 🛰️

- **Vibe Matching Algorithm**: Advanced compatibility scoring based on persona vectors and chat history analysis.
- **Chemistry Score Visualization**: Dynamic UI elements showing the "vibe" of a specific conversation (Heart animations, Aura shifts).
- **Group Conversations**: Support for multi-user emoji-driven rooms.
- **Conversation Artifacts**: "Memory Crystals" – AI-generated summaries or highlights of long-term chats.
- **E2E Encryption**: Privacy-focused mode for peer-to-peer messaging.
- **Emoji Combinator**: Experimental feature to "fuse" two emojis into a custom AI-generated sticker.

---

## Summary

The current technical stack (**Serverpod 2.x + Riverpod 2.x + Gemini 1.5 + GenUI**) is fully operational. The application successfully achieves "Emoji-to-Soul" translation, with a robust bot-driven tutorial and a functioning matchmaking ecosystem. Development is now shifting toward polishing the "vibe" via presence indicators and real-time visual feedback.
