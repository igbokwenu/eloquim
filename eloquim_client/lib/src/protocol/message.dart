/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'conversation.dart' as _i2;
import 'user.dart' as _i3;
import 'package:eloquim_client/src/protocol/protocol.dart' as _i4;

abstract class Message implements _i1.SerializableModel {
  Message._({
    this.id,
    required this.conversationId,
    this.conversation,
    required this.senderId,
    this.sender,
    required this.emojiSequence,
    this.rawIntent,
    required this.translatedText,
    String? tone,
    required this.personaUsed,
    double? confidenceScore,
    this.mediaGifUrl,
    this.replyToMsgId,
    DateTime? createdAt,
    this.deliveredAt,
    this.readAt,
    bool? isEncrypted,
  }) : tone = tone ?? 'casual',
       confidenceScore = confidenceScore ?? 0.0,
       createdAt = createdAt ?? DateTime.now(),
       isEncrypted = isEncrypted ?? false;

  factory Message({
    int? id,
    required int conversationId,
    _i2.Conversation? conversation,
    required int senderId,
    _i3.User? sender,
    required List<String> emojiSequence,
    String? rawIntent,
    required String translatedText,
    String? tone,
    required String personaUsed,
    double? confidenceScore,
    String? mediaGifUrl,
    int? replyToMsgId,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    bool? isEncrypted,
  }) = _MessageImpl;

  factory Message.fromJson(Map<String, dynamic> jsonSerialization) {
    return Message(
      id: jsonSerialization['id'] as int?,
      conversationId: jsonSerialization['conversationId'] as int,
      conversation: jsonSerialization['conversation'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Conversation>(
              jsonSerialization['conversation'],
            ),
      senderId: jsonSerialization['senderId'] as int,
      sender: jsonSerialization['sender'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.User>(jsonSerialization['sender']),
      emojiSequence: _i4.Protocol().deserialize<List<String>>(
        jsonSerialization['emojiSequence'],
      ),
      rawIntent: jsonSerialization['rawIntent'] as String?,
      translatedText: jsonSerialization['translatedText'] as String,
      tone: jsonSerialization['tone'] as String?,
      personaUsed: jsonSerialization['personaUsed'] as String,
      confidenceScore: (jsonSerialization['confidenceScore'] as num?)
          ?.toDouble(),
      mediaGifUrl: jsonSerialization['mediaGifUrl'] as String?,
      replyToMsgId: jsonSerialization['replyToMsgId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      isEncrypted: jsonSerialization['isEncrypted'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int conversationId;

  _i2.Conversation? conversation;

  int senderId;

  _i3.User? sender;

  List<String> emojiSequence;

  String? rawIntent;

  String translatedText;

  String tone;

  String personaUsed;

  double confidenceScore;

  String? mediaGifUrl;

  int? replyToMsgId;

  DateTime createdAt;

  DateTime? deliveredAt;

  DateTime? readAt;

  bool isEncrypted;

  /// Returns a shallow copy of this [Message]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Message copyWith({
    int? id,
    int? conversationId,
    _i2.Conversation? conversation,
    int? senderId,
    _i3.User? sender,
    List<String>? emojiSequence,
    String? rawIntent,
    String? translatedText,
    String? tone,
    String? personaUsed,
    double? confidenceScore,
    String? mediaGifUrl,
    int? replyToMsgId,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    bool? isEncrypted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Message',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      if (conversation != null) 'conversation': conversation?.toJson(),
      'senderId': senderId,
      if (sender != null) 'sender': sender?.toJson(),
      'emojiSequence': emojiSequence.toJson(),
      if (rawIntent != null) 'rawIntent': rawIntent,
      'translatedText': translatedText,
      'tone': tone,
      'personaUsed': personaUsed,
      'confidenceScore': confidenceScore,
      if (mediaGifUrl != null) 'mediaGifUrl': mediaGifUrl,
      if (replyToMsgId != null) 'replyToMsgId': replyToMsgId,
      'createdAt': createdAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      'isEncrypted': isEncrypted,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MessageImpl extends Message {
  _MessageImpl({
    int? id,
    required int conversationId,
    _i2.Conversation? conversation,
    required int senderId,
    _i3.User? sender,
    required List<String> emojiSequence,
    String? rawIntent,
    required String translatedText,
    String? tone,
    required String personaUsed,
    double? confidenceScore,
    String? mediaGifUrl,
    int? replyToMsgId,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    bool? isEncrypted,
  }) : super._(
         id: id,
         conversationId: conversationId,
         conversation: conversation,
         senderId: senderId,
         sender: sender,
         emojiSequence: emojiSequence,
         rawIntent: rawIntent,
         translatedText: translatedText,
         tone: tone,
         personaUsed: personaUsed,
         confidenceScore: confidenceScore,
         mediaGifUrl: mediaGifUrl,
         replyToMsgId: replyToMsgId,
         createdAt: createdAt,
         deliveredAt: deliveredAt,
         readAt: readAt,
         isEncrypted: isEncrypted,
       );

  /// Returns a shallow copy of this [Message]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Message copyWith({
    Object? id = _Undefined,
    int? conversationId,
    Object? conversation = _Undefined,
    int? senderId,
    Object? sender = _Undefined,
    List<String>? emojiSequence,
    Object? rawIntent = _Undefined,
    String? translatedText,
    String? tone,
    String? personaUsed,
    double? confidenceScore,
    Object? mediaGifUrl = _Undefined,
    Object? replyToMsgId = _Undefined,
    DateTime? createdAt,
    Object? deliveredAt = _Undefined,
    Object? readAt = _Undefined,
    bool? isEncrypted,
  }) {
    return Message(
      id: id is int? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation is _i2.Conversation?
          ? conversation
          : this.conversation?.copyWith(),
      senderId: senderId ?? this.senderId,
      sender: sender is _i3.User? ? sender : this.sender?.copyWith(),
      emojiSequence:
          emojiSequence ?? this.emojiSequence.map((e0) => e0).toList(),
      rawIntent: rawIntent is String? ? rawIntent : this.rawIntent,
      translatedText: translatedText ?? this.translatedText,
      tone: tone ?? this.tone,
      personaUsed: personaUsed ?? this.personaUsed,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      mediaGifUrl: mediaGifUrl is String? ? mediaGifUrl : this.mediaGifUrl,
      replyToMsgId: replyToMsgId is int? ? replyToMsgId : this.replyToMsgId,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      isEncrypted: isEncrypted ?? this.isEncrypted,
    );
  }
}
