import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:eloquim_client/eloquim_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

// Global client instance to be initialized in main.dart
late Client globalClient;

/// Initializes the Serverpod client and authentication
Future<void> initializeServerpodClient() async {
  const serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'http://localhost:8080/',
  );

  globalClient = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  await globalClient.auth.initialize();
}

// Provider for the Serverpod client
final serverpodClientProvider = Provider<Client>((ref) {
  return globalClient;
});

// Current user provider
// Note: This User is the custom User model from eloquim_client, not AuthUser
final currentUserProvider = StreamProvider<User?>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return _authStream(client);
});

Stream<User?> _authStream(Client client) {
  final controller = StreamController<User?>();
  final authManager = client.authSessionManager as FlutterAuthSessionManager?;

  void updateUser() async {
    if (authManager?.isAuthenticated ?? false) {
      try {
        // Fetch custom user object from backend
        // This assumes UserEndpoint exists and has getCurrentUser()
        final user = await client.user.getCurrentUser();
        controller.add(user);
      } catch (e) {
        // If error (e.g. network), we might still be 'signed in' but can't get profile
        // For now, emit null or maybe retry?
        print('Error fetching user profile: $e');
        controller.add(null);
      }
    } else {
      controller.add(null);
    }
  }

  // Initial fetch
  updateUser();

  // Listen for auth changes
  void listener() {
    updateUser();
  }

  authManager?.authInfoListenable.addListener(listener);

  controller.onCancel = () {
    authManager?.authInfoListenable.removeListener(listener);
    controller.close();
  };

  return controller.stream;
}

// Helper provider for authentication state boolean
final isAuthenticatedProvider = StreamProvider<bool>((ref) {
  final authManager =
      globalClient.authSessionManager as FlutterAuthSessionManager?;

  return Stream.multi((controller) {
    controller.add(authManager?.isAuthenticated ?? false);

    void listener() {
      controller.add(authManager?.isAuthenticated ?? false);
    }

    authManager?.authInfoListenable.addListener(listener);

    controller.onCancel = () {
      authManager?.authInfoListenable.removeListener(listener);
    };
  });
});
