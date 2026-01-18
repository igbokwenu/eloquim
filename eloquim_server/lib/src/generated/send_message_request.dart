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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:eloquim_server/src/generated/protocol.dart' as _i2;

abstract class SendMessageRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SendMessageRequest._({
    required this.conversationId,
    this.rawIntent,
    required this.emojiSequence,
    required this.tone,
    required this.personaId,
    this.mediaGifUrl,
    this.replyToMsgId,
  });

  factory SendMessageRequest({
    required int conversationId,
    String? rawIntent,
    required List<String> emojiSequence,
    required String tone,
    required String personaId,
    String? mediaGifUrl,
    int? replyToMsgId,
  }) = _SendMessageRequestImpl;

  factory SendMessageRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SendMessageRequest(
      conversationId: jsonSerialization['conversationId'] as int,
      rawIntent: jsonSerialization['rawIntent'] as String?,
      emojiSequence: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['emojiSequence'],
      ),
      tone: jsonSerialization['tone'] as String,
      personaId: jsonSerialization['personaId'] as String,
      mediaGifUrl: jsonSerialization['mediaGifUrl'] as String?,
      replyToMsgId: jsonSerialization['replyToMsgId'] as int?,
    );
  }

  int conversationId;

  String? rawIntent;

  List<String> emojiSequence;

  String tone;

  String personaId;

  String? mediaGifUrl;

  int? replyToMsgId;

  /// Returns a shallow copy of this [SendMessageRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SendMessageRequest copyWith({
    int? conversationId,
    String? rawIntent,
    List<String>? emojiSequence,
    String? tone,
    String? personaId,
    String? mediaGifUrl,
    int? replyToMsgId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SendMessageRequest',
      'conversationId': conversationId,
      if (rawIntent != null) 'rawIntent': rawIntent,
      'emojiSequence': emojiSequence.toJson(),
      'tone': tone,
      'personaId': personaId,
      if (mediaGifUrl != null) 'mediaGifUrl': mediaGifUrl,
      if (replyToMsgId != null) 'replyToMsgId': replyToMsgId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SendMessageRequest',
      'conversationId': conversationId,
      if (rawIntent != null) 'rawIntent': rawIntent,
      'emojiSequence': emojiSequence.toJson(),
      'tone': tone,
      'personaId': personaId,
      if (mediaGifUrl != null) 'mediaGifUrl': mediaGifUrl,
      if (replyToMsgId != null) 'replyToMsgId': replyToMsgId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SendMessageRequestImpl extends SendMessageRequest {
  _SendMessageRequestImpl({
    required int conversationId,
    String? rawIntent,
    required List<String> emojiSequence,
    required String tone,
    required String personaId,
    String? mediaGifUrl,
    int? replyToMsgId,
  }) : super._(
         conversationId: conversationId,
         rawIntent: rawIntent,
         emojiSequence: emojiSequence,
         tone: tone,
         personaId: personaId,
         mediaGifUrl: mediaGifUrl,
         replyToMsgId: replyToMsgId,
       );

  /// Returns a shallow copy of this [SendMessageRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SendMessageRequest copyWith({
    int? conversationId,
    Object? rawIntent = _Undefined,
    List<String>? emojiSequence,
    String? tone,
    String? personaId,
    Object? mediaGifUrl = _Undefined,
    Object? replyToMsgId = _Undefined,
  }) {
    return SendMessageRequest(
      conversationId: conversationId ?? this.conversationId,
      rawIntent: rawIntent is String? ? rawIntent : this.rawIntent,
      emojiSequence:
          emojiSequence ?? this.emojiSequence.map((e0) => e0).toList(),
      tone: tone ?? this.tone,
      personaId: personaId ?? this.personaId,
      mediaGifUrl: mediaGifUrl is String? ? mediaGifUrl : this.mediaGifUrl,
      replyToMsgId: replyToMsgId is int? ? replyToMsgId : this.replyToMsgId,
    );
  }
}
