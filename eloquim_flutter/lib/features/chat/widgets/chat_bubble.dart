// eloquim_flutter/lib/features/chat/widgets/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class ChatBubble extends ConsumerWidget {
  final Message message;

  const ChatBubble({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.valueOrNull;
    final isMine = currentUser != null && message.senderId == currentUser.id;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showTranslationDetails(context),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: _getBubbleColor(isMine, message.tone),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji sequence
              if (message.emojiSequence.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    message.emojiSequence.join(' '),
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              // Translated text
              Text(
                message.translatedText,
                style: TextStyle(
                  fontSize: 16,
                  color: isMine ? Colors.white : Colors.black87,
                ),
              ),
              // Confidence badge
              if (message.confidenceScore > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '${(message.confidenceScore * 100).toInt()}% confident',
                    style: TextStyle(
                      fontSize: 10,
                      color: isMine 
                          ? Colors.white.withOpacity(0.7)
                          : Colors.black54,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBubbleColor(bool isMine, String tone) {
    if (isMine) {
      switch (tone) {
        case 'flirty':
          return Colors.pink.shade300;
        case 'formal':
          return Colors.blueGrey.shade600;
        case 'enthusiastic':
          return Colors.orange.shade400;
        case 'cold':
          return Colors.blue.shade800;
        default:
          return Colors.blue.shade500;
      }
    }
    return Colors.grey.shade200;
  }

  void _showTranslationDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('👻 Ghost Translation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Emojis', message.emojiSequence.join(' ')),
            const SizedBox(height: 8),
            if (message.rawIntent != null)
              _buildDetailRow('Raw Intent', message.rawIntent!),
            const SizedBox(height: 8),
            _buildDetailRow('Translated', message.translatedText),
            const SizedBox(height: 8),
            _buildDetailRow('Tone', message.tone),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Confidence',
              '${(message.confidenceScore * 100).toStringAsFixed(1)}%',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}