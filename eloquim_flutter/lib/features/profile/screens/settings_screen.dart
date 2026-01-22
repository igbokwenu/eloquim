// eloquim_flutter/lib/features/profile/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            leading: const Icon(Icons.help),
            title: const Text('Help & FAQ'),
            onTap: () {
              // TODO: Navigate to help
            },
          ),

          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send Feedback'),
            onTap: () {
              // TODO: Show feedback dialog
            },
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
                  final sessionManager = ref.read(sessionManagerProvider);
                  await sessionManager.signOut();
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
                    'This action cannot be undone. All your data will be permanently deleted.',
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
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                // TODO: Implement account deletion
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deletion coming soon'),
                    ),
                  );
                }
              }
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
