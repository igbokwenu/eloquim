// eloquim_server/lib/src/endpoints/persona_endpoint.dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PersonaEndpoint extends Endpoint {
  Future<List<Persona>> getOfficialPersonas(Session session) async {
    return await Persona.db.find(
      session,
      where: (t) => t.isOfficial.equals(true),
      orderBy: (t) => t.name,
    );
  }

  Future<Persona?> getPersona(Session session, int personaId) async {
    return await Persona.db.findById(session, personaId);
  }

  Future<void> seedOfficialPersonas(Session session) async {
    final existing = await Persona.db.find(
      session,
      where: (t) => t.isOfficial.equals(true),
    );

    if (existing.isNotEmpty) return;

    final personas = [
      Persona(
        name: 'Gen Z',
        isOfficial: true,
        // FIX: Removed "creatorId: 0". It defaults to null automatically.
        description: 'Casual, playful, and meme-fluent.',
        traitsJson: '{"openness": 0.8, "humor": 0.9}',
        communicationStyle: 'casual',
        packVersion: '1.0',
        createdAt: DateTime.now(),
      ),
      Persona(
        name: 'Professional',
        isOfficial: true,
        description: 'Formal, clear, and respectful.',
        traitsJson: '{"openness": 0.5, "formality": 0.9}',
        communicationStyle: 'formal',
        packVersion: '1.0',
        createdAt: DateTime.now(),
      ),
      Persona(
        name: 'Romantic',
        isOfficial: true,
        description: 'Poetic, emotional, and expressive.',
        traitsJson: '{"openness": 0.9, "emotion": 0.9}',
        communicationStyle: 'poetic',
        packVersion: '1.0',
        createdAt: DateTime.now(),
      ),
    ];

    for (final persona in personas) {
      await Persona.db.insertRow(session, persona);
    }
  }

  Future<void> assignPersona(Session session, int personaId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');

    final userId = int.parse(authInfo.userIdentifier);

    final user = await User.db.findById(session, userId);
    if (user != null) {
      final persona = await Persona.db.findById(session, personaId);

      // Update using copyWith
      final updatedUser = user.copyWith(
        personaId: personaId,
        emojiSignature: persona != null
            ? _generateEmojiSignature(persona.name)
            : user.emojiSignature,
      );

      await User.db.updateRow(session, updatedUser);
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
