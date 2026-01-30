// eloquim_flutter/lib/features/chat/widgets/genui_catalog.dart
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'dart:math' as math;

/// Global event bus or simple callback for EmojiTray interactions
typedef EmojiSelectCallback = void Function(String emoji);
EmojiSelectCallback? globalOnEmojiSelected;

class EloquimCatalog {
  static Catalog asCatalog() {
    return Catalog([
      _toneIndicator,
      _emojiTray,
      _soulPacketStatus,
      _auraAtmosphere,
    ], catalogId: 'eloquim.chat.v1');
  }

  /// HELPER: Safely handles both raw Strings (AI shortcut) and Binding Maps (GenUI standard).
  /// We use 'dynamic' for context because the WidgetContext class name might vary
  /// or be unexported in specific package versions.
  static ValueNotifier<String?> _safeSubscribe(
    dynamic context,
    Object? rawData,
  ) {
    if (rawData is String) {
      // AI returned a raw string (e.g., "#FFFFFF") instead of a binding object
      return ValueNotifier<String?>(rawData);
    } else if (rawData is Map) {
      // AI returned the correct binding object (e.g., {"literalString": "#FFFFFF"})
      // We assume 'context' has a .dataContext property (duck typing)
      return context.dataContext.subscribeToString(
        rawData as Map<String, Object?>?,
      );
    }
    // Fallback
    return ValueNotifier<String?>(null);
  }

  static Color _parseHex(String? hex, Color fallback) {
    if (hex == null) return fallback;
    // Handle AI potentially returning color names
    final lower = hex.toLowerCase();
    if (lower == 'black') return Colors.black;
    if (lower == 'white') return Colors.white;
    if (lower == 'transparent') return Colors.transparent;

    if (!hex.startsWith('#')) return fallback;
    try {
      final cleanHex = hex.replaceAll('#', '');
      if (cleanHex.length == 6) {
        return Color(int.parse('0xFF$cleanHex'));
      } else if (cleanHex.length == 8) {
        return Color(int.parse('0x$cleanHex'));
      }
    } catch (_) {}
    return fallback;
  }

  static final _toneIndicator = CatalogItem(
    name: 'ToneIndicator',
    dataSchema: S.object(
      properties: {
        'tone': S.string(description: 'The current tone of the conversation.'),
        'color': S.string(description: 'HEX color string matching the tone.'),
        'label': S.string(description: 'A catchy label for the tone.'),
      },
      required: ['tone', 'color', 'label'],
    ),
    widgetBuilder: (context) {
      final data = context.data as Map<String, Object?>;

      final tone = _safeSubscribe(context, data['tone']);
      final colorStr = _safeSubscribe(context, data['color']);
      final label = _safeSubscribe(context, data['label']);

      return ValueListenableBuilder<String?>(
        valueListenable: tone,
        builder: (context, toneVal, _) {
          return ValueListenableBuilder<String?>(
            valueListenable: colorStr,
            builder: (context, c, _) {
              final color = _parseHex(c, Colors.blue);
              return ValueListenableBuilder<String?>(
                valueListenable: label,
                builder: (context, l, _) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 16, color: color),
                        const SizedBox(width: 8),
                        Text(
                          l ?? 'Neutral',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      );
    },
  );

  static final _emojiTray = CatalogItem(
    name: 'EmojiTray',
    dataSchema: S.object(
      properties: {
        'emojis': S.list(
          items: S.string(),
          description: 'List of recommended emojis.',
        ),
        'title': S.string(description: 'Title for the tray.'),
      },
      required: ['emojis'],
    ),
    widgetBuilder: (context) {
      final data = context.data as Map<String, Object?>;
      final emojis = data['emojis'] as List<dynamic>? ?? [];

      final title = _safeSubscribe(context, data['title']);

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: ValueListenableBuilder<String?>(
                valueListenable: title,
                builder: (context, t, _) {
                  return Text(
                    t ?? 'AI RECOMMENDATIONS',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Colors.white70,
                    ),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: emojis
                    .map((e) => _EmojiChip(emoji: e.toString()))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    },
  );

  static final _soulPacketStatus = CatalogItem(
    name: 'SoulPacketStatus',
    dataSchema: S.object(
      properties: {
        'status': S.string(description: 'Current status message.'),
      },
    ),
    widgetBuilder: (context) {
      final data = context.data as Map<String, Object?>;

      final status = _safeSubscribe(context, data['status']);

      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 12),
            ValueListenableBuilder<String?>(
              valueListenable: status,
              builder: (context, s, _) {
                return Text(
                  s ?? 'Syncing Soul Waves...',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );

  static final _auraAtmosphere = CatalogItem(
    name: 'AuraAtmosphere',
    dataSchema: S.object(
      properties: {
        'topColor': S.string(description: 'Top gradient color (HEX).'),
        'bottomColor': S.string(description: 'Bottom gradient color (HEX).'),
      },
      required: ['topColor', 'bottomColor'],
    ),
    widgetBuilder: (context) {
      final data = context.data as Map<String, Object?>;

      final tColorNotifier = _safeSubscribe(context, data['topColor']);
      final bColorNotifier = _safeSubscribe(context, data['bottomColor']);

      return _AuraBackground(
        topColorNotifier: tColorNotifier,
        bottomColorNotifier: bColorNotifier,
      );
    },
  );
}

class _AuraBackground extends StatefulWidget {
  final ValueNotifier<String?> topColorNotifier;
  final ValueNotifier<String?> bottomColorNotifier;

  const _AuraBackground({
    required this.topColorNotifier,
    required this.bottomColorNotifier,
  });

  @override
  State<_AuraBackground> createState() => _AuraBackgroundState();
}

class _AuraBackgroundState extends State<_AuraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.topColorNotifier,
        widget.bottomColorNotifier,
        _controller,
      ]),
      builder: (context, _) {
        final topColor = EloquimCatalog._parseHex(
          widget.topColorNotifier.value,
          const Color(0xFF32CD32),
        );
        final bottomColor = EloquimCatalog._parseHex(
          widget.bottomColorNotifier.value,
          const Color(0xFFF0FFF0),
        );

        return Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    topColor.withOpacity(0.4),
                    bottomColor.withOpacity(0.15),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Moving highlights
            Positioned(
              top: (math.sin(_controller.value * 2 * math.pi) * 50),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [topColor.withOpacity(0.1), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmojiChip extends StatelessWidget {
  final String emoji;
  const _EmojiChip({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Material(
        color: Colors.white,
        elevation: 2,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            globalOnEmojiSelected?.call(emoji);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
        ),
      ),
    );
  }
}
