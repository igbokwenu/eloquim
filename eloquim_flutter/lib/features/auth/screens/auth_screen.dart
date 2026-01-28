// eloquim_flutter/lib/features/auth/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final client = ref.watch(serverpodClientProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // App branding
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/eloquim_logo.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to Eloquim',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create an account to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Email authentication widget
                  Theme(
                    data: Theme.of(context).copyWith(
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.grey[100],
                      ),
                      elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    child: EmailSignInWidget(
                      client: client,
                      startScreen: EmailFlowScreen.login,
                      onTermsAndConditionsPressed: () {
                        // TODO: Show Terms and Conditions
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terms and Conditions')),
                        );
                      },
                      onPrivacyPolicyPressed: () {
                        // TODO: Show Privacy Policy
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Privacy Policy')),
                        );
                      },
                      onAuthenticated: () {
                        // After authentication, proceed to quiz
                        // Don't navigate here - let the router handle it
                        // The router will detect authentication and redirect appropriately
                      },
                      onError: (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
