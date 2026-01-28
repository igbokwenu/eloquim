import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:eloquim_client/eloquim_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

// Global client instance to be initialized in main.dart
late Client globalClient;

/// Initializes the Serverpod client and authentication
Future<void> initializeServerpodClient() async {
  // 1. Define your Production API URL here
  const productionUrl = 'https://eloquim.api.serverpod.space/';

  // 2. Define your Development API URL here
  const developmentUrl = 'http://127.0.0.1:8080/';

  // 3. Logic to select the correct URL
  // Priority:
  // A. Command line argument (--dart-define=SERVER_URL=...)
  // B. If Release Mode (Production) -> Use Production URL
  // C. Default -> Use Development URL
  String serverUrl = const String.fromEnvironment('SERVER_URL');

  if (serverUrl.isEmpty) {
    if (kReleaseMode) {
      serverUrl = productionUrl;
    } else {
      serverUrl = developmentUrl;
    }
  }

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

// Fetch a user by ID
final userProvider = FutureProvider.family<User?, int>((ref, userId) async {
  final client = ref.watch(serverpodClientProvider);
  try {
    return await client.user.getUser(userId);
  } catch (e) {
    return null;
  }
});
