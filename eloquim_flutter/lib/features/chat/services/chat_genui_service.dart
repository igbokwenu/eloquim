// eloquim_flutter/lib/features/chat/services/chat_genui_service.dart
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import '../widgets/genui_catalog.dart';

class ChatGenUiService {
  late final GenUiConversation conversation;
  late final A2uiMessageProcessor processor; // Publicly exposed for UI

  final Function(String surfaceId) onSurfaceAdded;
  final Function(String surfaceId) onSurfaceUpdated;
  final Function(String surfaceId) onSurfaceRemoved;
  final Function(String text) onTextResponse;

  ChatGenUiService({
    required this.onSurfaceAdded,
    required this.onSurfaceUpdated,
    required this.onSurfaceRemoved,
    required this.onTextResponse,
  }) {
    // 1. Create the custom catalog
    final customCatalog = EloquimCatalog.asCatalog();

    // 2. Create a COMBINED catalog.
    // We take the Core items and append our custom items.
     final combinedCatalog = Catalog(
      [...CoreCatalogItems.asCatalog().items, ...customCatalog.items],
      catalogId: 'eloquim.chat.combined',
    );


    // 3. Initialize Processor with the combined catalog
    processor = A2uiMessageProcessor(
      catalogs: [combinedCatalog],
    );

    // 4. Initialize Generator with the SAME combined catalog
    final contentGenerator = FirebaseAiContentGenerator(
      catalog: combinedCatalog, // Now the AI sees AuraAtmosphere and EmojiTray
      systemInstruction:
          '''
        # ROLE
        You are the Eloquim Visual Master. You communicate using DYNAMIC UI.
        
        # UI CONTROL RULES
        1. You have access to widgets like 'AuraAtmosphere', 'EmojiTray', and 'SoulPacketStatus'.
        2. ALWAYS use the `surfaceUpdate` tool to define component structures.
        3. ALWAYS use the `beginRendering` tool after `surfaceUpdate` to display the UI.
        4. DO NOT respond with conversational text. Use UI elements instead.
        
        # PERSISTENT SURFACES
        - "atmosphere": Use AuraAtmosphere widget.
          * Romantic: Top #FFC0CB, Bottom #6A0DAD
          * Hype: Top #FF4500, Bottom #FFD700
          * Chill: Top #000080, Bottom #87CEEB
          * Casual: Top #32CD32, Bottom #F0FFF0
        
        - "suggestions": Use EmojiTray widget. 
        
        # WORKFLOW
        - When initialized: Render "atmosphere" immediately.
        - When a message arrives: Update "atmosphere" based on tone, and if it's a partner message, update "suggestions".

        ${GenUiPromptFragments.basicChat}
      ''',
    );

    conversation = GenUiConversation(
      a2uiMessageProcessor: processor,
      contentGenerator: contentGenerator,
      onSurfaceAdded: (added) => onSurfaceAdded(added.surfaceId),
      onSurfaceUpdated: (update) => onSurfaceUpdated(update.surfaceId),
      onSurfaceDeleted: (removed) => onSurfaceRemoved(removed.surfaceId),
      onTextResponse: (text) {
        if (text.isNotEmpty) onTextResponse(text);
      },
    );

    _initializeAtmosphere();
  }

  void _initializeAtmosphere() {
    conversation.sendRequest(
      UserMessage.text(
        "INITIALIZE: Setup 'atmosphere' surface with AuraAtmosphere for Casual tone.",
      ),
    );
  }

  void dispose() {
    conversation.dispose();
  }

  Future<void> updateWithNewMessage(
    String text,
    String tone, {
    bool isFromUser = true,
  }) async {
    final command = isFromUser
        ? "USER MESSAGE: '$text'. TONE: '$tone'. Sync atmosphere."
        : "PARTNER MESSAGE: '$text'. TONE: '$tone'. Sync atmosphere and update suggestions tray.";

    await conversation.sendRequest(UserMessage.text(command));
  }

  Future<void> onToneChanged(String newTone) async {
    await conversation.sendRequest(
      UserMessage.text(
        "TONE SHIFT: User switched to '$newTone'. Update background atmosphere immediately.",
      ),
    );
  }
}
