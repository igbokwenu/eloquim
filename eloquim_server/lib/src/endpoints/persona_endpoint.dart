// eloquim_server/lib/src/endpoints/persona_endpoint.dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PersonaEndpoint extends Endpoint {
  
  /// Get all official personas
  Future<List<Persona>> getOfficialPersonas(Session session) async {
    return await Persona.db.find(
      session,
      where: (t) => t.isOfficial.equals(true),
      orderBy: (t) => t.name,
    );
  }

  /// Get persona by ID
  Future<Persona?> getPersona(Session session, int personaId) async {
    return await Persona.db.findById(session, personaId);
  }

  /// Create official personas (admin only - for initial setup)
  Future<void> seedOfficialPersonas(Session session) async {
    // Check if already seeded
    final existing = await Persona.db.find(
      session,
      where: (t) => t.isOfficial.equals(true),
    );

    if (existing.isNotEmpty) {
      return; // Already seeded
    }

    final personas = [
      Persona(
        name: 'Gen Z',
        isOfficial: true,
        description: 'Casual, playful, and meme-fluent. Express yourself with modern vibes.',
        traitsJson: '{"openness": 0.8, "humor": 0.9, "formality": 0.2}',
        communicationStyle: 'casual',
        packVersion: '1.0',
        createdAt: DateTime.now(),
      ),
      Persona(
        name: 'Professional',
        isOfficial: true,
        description: 'Formal, clear, and respectful. Perfect for work communications.',
        traitsJson: '{"openness": 0.5, "humor": 0.3, "formality": 0.9}',
        communicationStyle: 'formal',
        packVersion: '1.0',
        createdAt: DateTime.now(),
      ),
      Persona(
        name: 'Romantic',
        isOfficial: true,
        description: 'Poetic, emotional, and expressive. Wear your heart on your sleeve.',
        traitsJson: '{"openness": 0.9, "humor": 0.5, "formality": 0.4}',
        communicationStyle: 'poetic',
        packVersion: '1.0',
        createdAt: DateTime.now(),
      ),
    ];

    for (final persona in personas) {
      await Persona.db.insertRow(session, persona);
    }
  }

  /// Assign persona to user
  Future<void> assignPersona(Session session, int personaId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final user = await User.db.findById(session, authInfo.userId);
    if (user != null) {
      user.personaId = personaId;
      
      // Generate emoji signature based on persona
      final persona = await Persona.db.findById(session, personaId);
      if (persona != null) {
        user.emojiSignature = _generateEmojiSignature(persona.name);
      }
      
      await User.db.updateRow(session, user);
    }
  }

  String _generateEmojiSignature(String personaName) {
    switch (personaName) {
      case 'Gen Z':
        return '✨🎵💫';
      case 'Professional':
        return '💼📊🎯';
      case 'Romantic':
        return '💖✨🌙';
      default:
        return '✨🎵💫';
    }
  }
}