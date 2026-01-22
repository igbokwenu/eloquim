// eloquim_flutter/lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Emoji signature avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.emojiSignature,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Username
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Email if available
                if (user.email != null)
                  Text(
                    user.email!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 32),

                // Profile info cards
                _buildInfoCard(
                  'Emoji Signature',
                  user.emojiSignature,
                  Icons.auto_awesome,
                ),
                const SizedBox(height: 16),

                if (user.personaId != null)
                  FutureBuilder(
                    future: ref
                        .read(serverpodClientProvider)
                        .persona
                        .getPersona(user.personaId!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return _buildInfoCard(
                          'Persona',
                          snapshot.data!.name,
                          Icons.person,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                const SizedBox(height: 16),

                if (user.age != null)
                  _buildInfoCard(
                    'Age',
                    '${user.age}',
                    Icons.cake,
                  ),
                const SizedBox(height: 16),

                if (user.country != null)
                  _buildInfoCard(
                    'Country',
                    user.country!,
                    Icons.public,
                  ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  'Member Since',
                  _formatDate(user.createdAt),
                  Icons.calendar_today,
                ),
                const SizedBox(height: 32),

                // Edit profile button
                FilledButton.icon(
                  onPressed: () {
                    // TODO: Navigate to edit profile
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
