// eloquim_flutter/lib/features/profile/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // App Settings Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'App Settings',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Default Tone'),
            subtitle: const Text('Casual'),
            onTap: () {
              // TODO: Show tone selector dialog
            },
          ),

          SwitchListTile(
            secondary: const Icon(Icons.lightbulb),
            title: const Text('Emoji Suggestions'),
            subtitle: const Text('Show smart emoji recommendations'),
            value: true,
            onChanged: (value) {
              // TODO: Save preference
            },
          ),

          SwitchListTile(
            secondary: const Icon(Icons.visibility),
            title: const Text('Ghost Translation'),
            subtitle: const Text('Long-press to view translation details'),
            value: true,
            onChanged: (value) {
              // TODO: Save preference
            },
          ),

          const Divider(height: 32),

          // Help & Support Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Replay Tutorial'),
            onTap: () {
              context.push('/tutorial');
            },
          ),


          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send Feedback'),
            onTap: () {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'eloquim@habilisfusion.co',
                query: 'subject=Eloquim Feedback',
              );
              launchUrl(emailLaunchUri);
            },
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () => context.push('/privacy'),
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            onTap: () => context.push('/terms'),
          ),

          const Divider(height: 32),

          // Account Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Reset Password'),
            onTap: () async {
              final email = userAsync.value?.email;

              if (email == null) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No email associated with this account'),
                    ),
                  );
                }
                return;
              }

              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Password'),
                  content: Text('Send a password reset email to $email?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Send'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                try {
                  final client = ref.read(serverpodClientProvider);
                  await client.emailIdp.startPasswordReset(
                    email: email,
                  );
                  // In a real app, you might navigate to a screen to enter the code
                  // but for now, we just initiate the flow.
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reset email sent!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                try {
                  final client = ref.read(serverpodClientProvider);
                  await client.auth.signOutDevice();
                  if (context.mounted) {
                    context.go('/welcome');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Account'),
                  content: const Text(
                    'This action cannot be undone. All your messages, matches, and profile data will be permanently deleted.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete Permanently'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                try {
                  final client = ref.read(serverpodClientProvider);
                  // 1. Delete account data on server
                  await client.user.deleteAccount();
                  // 2. Sign out on client
                  await client.auth.signOutDevice();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account deleted successfully'),
                      ),
                    );
                    context.go('/welcome');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting account: $e')),
                    );
                  }
                }
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            subtitle: Text(
              '${userAsync.value?.username ?? ''} • ${userAsync.value?.country ?? ''}',
            ),
            onTap: () {
              context.push('/profile-setup');
            },
          ),

          const SizedBox(height: 32),

          // App Info
          const Center(
            child: Column(
              children: [
                Text(
                  'Eloquim',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
