// eloquim_flutter/lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/quiz_screen.dart';
import '../../features/onboarding/screens/quiz_result_screen.dart';
import '../../features/onboarding/screens/tutorial_screen.dart';
import '../../features/chat/screens/conversation_list_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/matchmaking/screens/find_match_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../providers/serverpod_client_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticatedAsync = ref.watch(isAuthenticatedProvider);
  final isAuthenticated = isAuthenticatedAsync.asData?.value ?? false;

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // If not authenticated and not on welcome/quiz, redirect to welcome
      if (!isAuthenticated &&
          !state.matchedLocation.startsWith('/welcome') &&
          !state.matchedLocation.startsWith('/quiz')) {
        return '/welcome';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/conversations',
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) => const QuizScreen(),
      ),
      GoRoute(
        path: '/quiz-result',
        builder: (context, state) {
          final persona = state.extra as String?;
          return QuizResultScreen(assignedPersona: persona ?? 'Gen Z');
        },
      ),
      GoRoute(
        path: '/tutorial',
        builder: (context, state) => const TutorialScreen(),
      ),
      GoRoute(
        path: '/conversations',
        builder: (context, state) => const ConversationListScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ChatScreen(conversationId: id);
        },
      ),
      GoRoute(
        path: '/find-match',
        builder: (context, state) => const FindMatchScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

// Helper provider for authentication state
final isAuthenticatedProvider = StreamProvider<bool>((ref) async* {
  final sessionManager = ref.watch(sessionManagerProvider);
  await for (final userInfo in sessionManager.onUserChanged) {
    yield userInfo != null;
  }
});
