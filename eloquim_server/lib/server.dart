import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
// FIX 1: Import mailer with a prefix to avoid conflict with your Chat 'Message' class
import 'package:mailer/mailer.dart' as mail;
import 'package:mailer/smtp_server.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';
import 'src/endpoints/persona_endpoint.dart';
import 'src/endpoints/user_endpoint.dart';

// Define SMTP Server globally
SmtpServer? _smtpServer;

void run(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());

  // 1. SETUP EMAIL (SMTP)
  final smtpEmail = pod.getPassword('smtpUsername');
  final smtpPassword = pod.getPassword('smtpPassword');

  if (smtpEmail != null && smtpPassword != null) {
    // FIX: Using custom SMTP server instead of hardcoded Gmail
    _smtpServer = SmtpServer(
      'habilisfusion.co',
      port: 465,
      ssl: true,
      username: smtpEmail,
      password: smtpPassword,
    );
  } else {
    print(
      'WARNING: SMTP credentials not found in passwords.yaml. Emails will be logged to console.',
    );
  }

  // 2. INITIALIZE AUTH
  pod.initializeAuthServices(
    userProfileConfig: UserProfileConfig(
      onAfterUserProfileCreated:
          (session, userProfile, {required transaction}) async {
            await AuthServices.instance.userProfiles.setDefaultUserImage(
              session,
              userProfile.authUserId,
              transaction: transaction,
            );
          },
    ),
    tokenManagerBuilders: [
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode:
            (
              session, {
              required email,
              required verificationCode,
              required accountRequestId,
              required transaction,
            }) async {
              await _sendEmail(
                session,
                to: email,
                subject: 'Verify your Eloquim Account',
                text: 'Your verification code is: $verificationCode',
              );
            },
        sendPasswordResetVerificationCode:
            (
              session, {
              required email,
              required verificationCode,
              required passwordResetRequestId,
              required transaction,
            }) async {
              await _sendEmail(
                session,
                to: email,
                subject: 'Reset your Password',
                text: 'Your password reset code is: $verificationCode',
              );
            },
      ),
    ],
  );

  // 3. WEB SERVER ROUTES
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    pod.webServer.addRoute(
      FlutterRoute(Directory(Uri(path: 'web/app').toFilePath())),
      '/app',
    );
  } else {
    pod.webServer.addRoute(
      StaticRoute.file(
        File(Uri(path: 'web/pages/build_flutter_app.html').toFilePath()),
      ),
      '/app/**',
    );
  }

  // 4. START SERVER
  await pod.start();

  // 5. SEED DATA
  try {
    final session = await pod.createSession();
    final personaEndpoint = PersonaEndpoint();
    await personaEndpoint.seedOfficialPersonas(session);

    // Seed Bot Users
    final userEndpoint = UserEndpoint();
    await userEndpoint.seedBots(session);

    await session.close();
    print('Seeding check complete.');
  } catch (e) {
    print('Error during seeding: $e');
  }
}

/// Helper function to send emails
Future<void> _sendEmail(
  Session session, {
  required String to,
  required String subject,
  required String text,
}) async {
  // 1. Get API Key
  final apiKey = Platform.environment['RESEND_API_KEY'];

  if (apiKey != null) {
    try {
      final uri = Uri.parse('https://api.resend.com/emails');

      // 2. Perform the request
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          // IMPORTANT: If you haven't verified 'habilisfusion.co' on Resend yet,
          // you MUST use 'onboarding@resend.dev' as the 'from' address.
          // If you HAVE verified it, you can use 'eloquim@habilisfusion.co'
          'from': 'Eloquim <onboarding@resend.dev>',
          'to': [to],
          'subject': subject,
          'html': '<p>$text</p>',
        }),
      );

      // 3. LOGGING FIX: Use print() instead of session.log()
      // The session might be closed by the time this line runs.
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ EMAIL SUCCESS: Sent to $to');
      } else {
        print('❌ EMAIL FAILED: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('❌ EMAIL EXCEPTION: $e');
    }
  } else {
    // Local fallback
    print('⚠️ EMAIL SIMULATION (No API Key) to: $to');
    print('Content: $text');
  }
}
