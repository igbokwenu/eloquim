// eloquim_server/lib/src/server.dart
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
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

  // 1. Initialize Auth Services
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfigFromPasswords(), // Reads secrets from config/passwords.yaml
    ],
    identityProviderBuilders: [
      // 2. Email Provider Configuration
      EmailIdpConfigFromPasswords(
        // Optional: Customize email verification behavior here
        sendRegistrationVerificationCode: (session, {required email, required verificationCode, required accountRequestId, required transaction}) {
          print('Verification Code for $email: $verificationCode');
          // In production, integrate SendGrid/Resend here
          return Future.value();
        },
        sendPasswordResetVerificationCode: (session, {required email, required verificationCode, required passwordResetRequestId, required transaction}) {
           print('Password Reset Code for $email: $verificationCode');
           return Future.value();
        },
      ),
    ],
  );

  // Seed official personas on startup
  await pod.start();
  
  // Run seed function
  final session = await pod.createSession();
  final personaEndpoint = PersonaEndpoint();
  await personaEndpoint.seedOfficialPersonas(session);
  await session.close();
}