// eloquim_flutter/lib/features/legal/screens/privacy_policy_screen.dart
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Effective Date: January 29, 2026',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Introduction',
              'Welcome to Eloquim. We respect your privacy and are committed to protecting your personal data.',
            ),
            _buildSection(
              '2. Data We Collect',
              'We collect information you provide directly to us, such as when you create an account, update your profile, and communicate with others using emojis. This includes your username, age, country, and the content of your messages (which are processed by AI for translation).',
            ),
            _buildSection(
              '3. How We Use Your Data',
              'We use your data to provide and improve our communication services, personalize your experience with AI personas, and maintain the security of our platform.',
            ),
            _buildSection(
              '4. AI Processing',
              'Your messages are processed using advanced AI models (like Gemini) to provide emoji-to-text translation. No human reads your messages unless required for legal compliance or safety investigations.',
            ),
            _buildSection(
              '5. Data Security',
              'We implement appropriate security measures to prevent your personal data from being accidentally lost, used, or accessed in an unauthorized way.',
            ),
            _buildSection(
              '6. Contact Us',
              'If you have any questions about this Privacy Policy, please contact me at eloquim@habilisfusion.co',
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
