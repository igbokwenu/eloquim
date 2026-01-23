import 'dart:async';
// eloquim_flutter/lib/core/providers/serverpod_client_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:eloquim_client/eloquim_client.dart';

import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

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
final currentUserProvider = StreamProvider<User?>((ref) {
  final client = ref.watch(serverpodClientProvider);
  final sessionManager = ref.watch(sessionManagerProvider);

  // We need to listen to the auth module's changes.
  // Since we cast to dynamic, we assume 'auth' exists and has 'authInfoListenable'.
  final authModule = (client.modules as dynamic).auth;

  // Create a stream that emits when auth info changes.
  // Note: This is a simplified stream creation.
  return _authStream(authModule, client);
});

Stream<User?> _authStream(dynamic authModule, Client client) async* {
  // Emit initial state
  if (authModule.isSignedIn) {
    try {
      yield await client.user.getCurrentUser();
    } catch (_) {
      yield null;
    }
  } else {
    yield null;
  }

  // Monitor changes
  // Ideally use a stream controller, but here we can use a simple loop or Stream.periodic check if listenable not easily streamable without StreamController boilerplate.
  // Better: Create a controller.
  final controller = StreamController<User?>();

  void listener() async {
    if (authModule.isSignedIn) {
      try {
        final user = await client.user.getCurrentUser();
        controller.add(user);
      } catch (_) {
        controller.add(null);
      }
    } else {
      controller.add(null);
    }
  }

  authModule.authInfoListenable.addListener(listener);

  controller.onCancel = () {
    authModule.authInfoListenable.removeListener(listener);
    controller.close();
  };

  yield* controller.stream;
}
