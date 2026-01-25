// eloquim_flutter/lib/main.dart
import 'package:eloquim/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

import 'core/providers/serverpod_client_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeServerpodClient();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    const ProviderScope(
      child: EloquimApp(),
    ),
  );
}

class EloquimApp extends ConsumerWidget {
  const EloquimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Eloquim',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
