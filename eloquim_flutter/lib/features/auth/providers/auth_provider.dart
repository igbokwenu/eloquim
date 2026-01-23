// eloquim_flutter/lib/features/auth/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../../../core/providers/serverpod_client_provider.dart';

final authProvider = Provider<IdpSignIn>((ref) {
  final client = ref.watch(serverpodClientProvider);
  // Ensure we handle the potentially missing 'auth' module accessor gracefully or via dynamic dispatch if generated code is desync
  return IdpSignIn((client.modules as dynamic).auth);
});

class IdpSignIn {
  final dynamic authModule;
  IdpSignIn(this.authModule);
}

final isAuthenticatedProvider = StreamProvider<bool>((ref) async* {
  final currentUserAsync = ref.watch(currentUserProvider);
  yield currentUserAsync.asData?.value != null;
});
