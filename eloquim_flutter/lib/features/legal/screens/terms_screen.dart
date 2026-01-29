// eloquim_flutter/lib/features/legal/screens/terms_screen.dart
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Service',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: January 29, 2026',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Agreement to Terms',
              'By accessing or using Eloquim, you agree to be bound by these Terms of Service. If you do not agree, do not use the service.',
            ),
            _buildSection(
              '2. User Conduct',
              'You agree not to use Eloquim for any unlawful purpose or to harass, abuse, or harm another person. Use of the emoji-to-text translation for harmful communication is strictly prohibited.',
            ),
            _buildSection(
              '3. Account Responsibility',
              'You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account.',
            ),
            _buildSection(
              '4. Limitation of Liability',
              'Eloquim is provided "as is". We are not liable for any indirect, incidental, or consequential damages arising from your use of the service.',
            ),
            _buildSection(
              '5. Termination',
              'We reserve the right to terminate or suspend your account at our sole discretion, without notice, for conduct that we believe violates these Terms.',
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
