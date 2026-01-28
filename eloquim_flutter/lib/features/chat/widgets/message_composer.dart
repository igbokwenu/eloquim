// eloquim_flutter/lib/features/chat/widgets/message_composer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../../core/providers/serverpod_client_provider.dart';
import '../../../shared/constants/tone_constants.dart';

class MessageComposer extends ConsumerStatefulWidget {
  final Function(String text, List<String>? emojis) onSend;
  final String currentTone;
  final Function(String tone) onToneChanged;
  final List<Message> history;

  const MessageComposer({
    required this.onSend,
    required this.currentTone,
    required this.onToneChanged,
    required this.history,
    super.key,
  });

  @override
  ConsumerState<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends ConsumerState<MessageComposer> {
  List<String> selectedEmojis = [];

  // A curated list of 50 common emojis for the keyboard v1
  final List<String> standardEmojis = [
    '👋',
    '😊',
    '😂',
    '🥰',
    '😎',
    '🤔',
    '🙄',
    '😤',
    '😭',
    '🤯',
    '👍',
    '🙌',
    '👏',
    '🔥',
    '✨',
    '💯',
    '❤️',
    '💖',
    '👀',
    '💭',
    '🍕',
    '☕',
    '🍦',
    '🎮',
    '🎵',
    '📸',
    '✈️',
    '🏠',
    '💼',
    '⏰',
    '☀️',
    '🌙',
    '🌈',
    '🌊',
    '🌸',
    '🐱',
    '🐶',
    '🚀',
    '🎁',
    '💰',
    '🤫',
    '😏',
    '🤤',
    '😴',
    '🤝',
    '✌️',
    '💪',
    '🙏',
    '📍',
    '✅',
  ];

  final List<String> greetingEmojis = ['👋', '😊', '🙌', '✨', '🌸', '☀️'];

  void _handleSend() {
    if (selectedEmojis.isEmpty) return;

    widget.onSend('', selectedEmojis);
    setState(() {
      selectedEmojis = [];
    });
  }

  void _addEmoji(String emoji) {
    if (selectedEmojis.length >= 3) {
      // Show some feedback or just ignore
      return;
    }
    setState(() {
      selectedEmojis.add(emoji);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Find last message from the partner for recommendations
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.asData?.value;

    final lastPartnerMessage = widget.history.reversed
        .where((m) => m.senderId != currentUser?.id)
        .firstOrNull;

    final recommendedEmojis = lastPartnerMessage?.recommendedEmojis ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tone Selector at the top
            _buildToneSelector(),

            const Divider(height: 1),

            // Recommended Emojis (Quick Responses)
            if (recommendedEmojis.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '✨ Suggested Quick Responses',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildRecommendedRow(recommendedEmojis),
            ],

            // Selected Emojis Preview
            _buildSelectedEmojisRow(),

            // Emoji Keyboard
            _buildEmojiKeyboard(),

            // Send Button
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildToneSelector() {
    return Container(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: ToneConstants.tones.length,
        itemBuilder: (context, index) {
          final tone = ToneConstants.tones[index];
          final isSelected = tone == widget.currentTone;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text('${ToneConstants.toneEmojis[tone] ?? ''} $tone'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) widget.onToneChanged(tone);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedRow(List<String> emojis) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.blue.withOpacity(0.05),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          final emoji = emojis[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              label: Text(emoji, style: const TextStyle(fontSize: 24)),
              onPressed: () => _addEmoji(emoji),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedEmojisRow() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedEmojis.isEmpty)
              const Text(
                'Select up to 3 emojis...',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ...selectedEmojis.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        top: -10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            size: 20,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedEmojis.removeAt(entry.key);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiKeyboard() {
    // Merge greetings into the top if no history
    final displayEmojis = widget.history.isEmpty
        ? [
            ...greetingEmojis,
            ...standardEmojis.where((e) => !greetingEmojis.contains(e)),
          ]
        : standardEmojis;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: displayEmojis.length,
        itemBuilder: (context, index) {
          final emoji = displayEmojis[index];
          return InkWell(
            onTap: () => _addEmoji(emoji),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSendButton() {
    // Check if we are currently sending (optimistically added message with negative ID)
    final isSending = widget.history.any((m) => m.id != null && m.id! < 0);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: FilledButton.icon(
          onPressed: (selectedEmojis.isEmpty || isSending) ? null : _handleSend,
          icon: isSending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.send),
          label: Text(isSending ? 'Creating Soul Packet...' : 'Send Emojis'),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
