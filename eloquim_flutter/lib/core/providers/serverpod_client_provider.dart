// eloquim_flutter/lib/core/providers/serverpod_client_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:eloquim_client/eloquim_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

// Initialize the Serverpod client
final serverpodClientProvider = Provider<Client>((ref) {
  // Replace with your server URL
  // For local development: 'http://localhost:8080/'
  // For production: 'https://your-server.com/'
  const serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'http://localhost:8080/',
  );

  return Client(
    serverUrl,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();
});

// Session manager provider
final sessionManagerProvider = Provider<SessionManager>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return SessionManager(
    caller: (client.modules as dynamic).auth,
  );
});

// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) async* {
  final client = ref.watch(serverpodClientProvider);
  final sessionManager = ref.watch(sessionManagerProvider);

  // Listen to authentication state
  await for (final userInfo in sessionManager.onUserChanged) {
    if (userInfo == null) {
      yield null;
    } else {
      // Fetch full user profile
      try {
        final user = await client.user.getCurrentUser();
        yield user;
      } catch (e) {
        yield null;
      }
    }
  }
});
