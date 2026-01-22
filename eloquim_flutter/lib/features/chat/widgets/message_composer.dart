// eloquim_flutter/lib/features/chat/widgets/message_composer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/constants/tone_constants.dart';
import '../providers/recommendation_provider.dart';

class MessageComposer extends ConsumerStatefulWidget {
  final Function(String text, List<String>? emojis) onSend;
  final String currentTone;
  final Function(String tone) onToneChanged;

  const MessageComposer({
    required this.onSend,
    required this.currentTone,
    required this.onToneChanged,
    super.key,
  });

  @override
  ConsumerState<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends ConsumerState<MessageComposer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> selectedEmojis = [];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty && selectedEmojis.isEmpty) return;

    widget.onSend(text, selectedEmojis.isEmpty ? null : selectedEmojis);
    _controller.clear();
    setState(() {
      selectedEmojis = [];
    });
    _focusNode.requestFocus();
  }

  void _addEmoji(String emoji) {
    setState(() {
      selectedEmojis.add(emoji);
    });
  }

  @override
  Widget build(BuildContext context) {
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Emoji suggestions
            if (recommendationsAsync.valueOrNull != null &&
                recommendationsAsync.value!.singles.isNotEmpty)
              _buildSuggestions(recommendationsAsync.value!.singles),

            // Tone selector
            _buildToneSelector(),

            // Selected emojis
            if (selectedEmojis.isNotEmpty) _buildSelectedEmojis(),

            // Input field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Emoji picker button
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {
                      // TODO: Show emoji picker
                    },
                  ),

                  // Text input
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Type or select emojis...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (text) {
                        // Trigger recommendations
                        if (text.isNotEmpty) {
                          ref.read(recommendationsProvider.notifier)
                              .getRecommendations(text);
                        }
                      },
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Send button
                  FilledButton(
                    onPressed: _handleSend,
                    style: FilledButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(List<String> suggestions) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final emoji = suggestions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: () => _addEmoji(emoji),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToneSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ToneConstants.tones.length,
        itemBuilder: (context, index) {
          final tone = ToneConstants.tones[index];
          final isSelected = tone == widget.currentTone;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(ToneConstants.toneEmojis[tone] ?? ''),
                  const SizedBox(width: 4),
                  Text(tone),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  widget.onToneChanged(tone);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedEmojis() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 8,
        children: [
          ...selectedEmojis.asMap().entries.map((entry) {
            final index = entry.key;
            final emoji = entry.value;
            return Chip(
              label: Text(emoji, style: const TextStyle(fontSize: 20)),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                setState(() {
                  selectedEmojis.removeAt(index);
                });
              },
            );
          }),
        ],
      ),
    );
  }
}