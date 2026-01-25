// eloquim_flutter/lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/quiz_screen.dart';
import '../../features/onboarding/screens/quiz_result_screen.dart';
import '../../features/onboarding/screens/tutorial_screen.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/chat/screens/conversation_list_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/matchmaking/screens/find_match_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../providers/serverpod_client_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final currentUserAsync = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authManager =
          globalClient.authSessionManager as FlutterAuthSessionManager?;
      final isAuthenticated = authManager?.isAuthenticated ?? false;
      final currentUser = currentUserAsync.asData?.value;
      final path = state.matchedLocation;

      // Public routes that don't require authentication
      final publicRoutes = ['/welcome', '/auth'];
      final isPublicRoute = publicRoutes.any((route) => path.startsWith(route));

      // If not authenticated and not on a public route, redirect to welcome
      if (!isAuthenticated && !isPublicRoute) {
        return '/welcome';
      }

      // If authenticated but user hasn't completed onboarding
      if (isAuthenticated && currentUser != null) {
        // Check if user has completed tutorial
        if (!currentUser.hasDoneTutorial) {
          // Allow access to onboarding routes
          final onboardingRoutes = ['/quiz', '/quiz-result', '/tutorial'];
          if (!onboardingRoutes.any((route) => path.startsWith(route))) {
            // If not on an onboarding route, redirect to quiz
            return '/quiz';
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) {
          final authManager =
              globalClient.authSessionManager as FlutterAuthSessionManager?;
          final isAuthenticated = authManager?.isAuthenticated ?? false;
          return isAuthenticated ? '/conversations' : '/welcome';
        },
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
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
