// eloquim_flutter/lib/features/auth/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../../../core/providers/serverpod_client_provider.dart';

final authProvider = Provider<IdpSignIn>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return IdpSignIn(client.modules.auth);
});

final isAuthenticatedProvider = StreamProvider<bool>((ref) async* {
  final sessionManager = ref.watch(sessionManagerProvider);
  await for (final userInfo in sessionManager.onUserChanged) {
    yield userInfo != null;
  }
});