// eloquim_server/lib/src/server.dart
import 'package:serverpod/serverpod.dart';
import 'endpoints/chat_endpoint.dart';
import 'endpoints/conversation_endpoint.dart';
import 'endpoints/persona_endpoint.dart';
import 'endpoints/recommendation_endpoint.dart';
import 'endpoints/user_endpoint.dart';
import 'generated/protocol.dart';
import 'generated/endpoints.dart';

void run(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Seed official personas on startup
  await pod.start();
  
  // Run seed function
  final session = await pod.createSession();
  final personaEndpoint = PersonaEndpoint();
  await personaEndpoint.seedOfficialPersonas(session);
  await session.close();
}