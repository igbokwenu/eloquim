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
import 'persona.dart' as _i2;
import 'package:eloquim_client/src/protocol/protocol.dart' as _i3;

abstract class EmojiMapping implements _i1.SerializableModel {
  EmojiMapping._({
    this.id,
    required this.personaId,
    this.persona,
    required this.emojiSequence,
    required this.canonicalText,
    required this.contextTags,
    int? usageCount,
    DateTime? createdAt,
  }) : usageCount = usageCount ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory EmojiMapping({
    int? id,
    required int personaId,
    _i2.Persona? persona,
    required String emojiSequence,
    required String canonicalText,
    required List<String> contextTags,
    int? usageCount,
    DateTime? createdAt,
  }) = _EmojiMappingImpl;

  factory EmojiMapping.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmojiMapping(
      id: jsonSerialization['id'] as int?,
      personaId: jsonSerialization['personaId'] as int,
      persona: jsonSerialization['persona'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Persona>(
              jsonSerialization['persona'],
            ),
      emojiSequence: jsonSerialization['emojiSequence'] as String,
      canonicalText: jsonSerialization['canonicalText'] as String,
      contextTags: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['contextTags'],
      ),
      usageCount: jsonSerialization['usageCount'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int personaId;

  _i2.Persona? persona;

  String emojiSequence;

  String canonicalText;

  List<String> contextTags;

  int usageCount;

  DateTime createdAt;

  /// Returns a shallow copy of this [EmojiMapping]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmojiMapping copyWith({
    int? id,
    int? personaId,
    _i2.Persona? persona,
    String? emojiSequence,
    String? canonicalText,
    List<String>? contextTags,
    int? usageCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmojiMapping',
      if (id != null) 'id': id,
      'personaId': personaId,
      if (persona != null) 'persona': persona?.toJson(),
      'emojiSequence': emojiSequence,
      'canonicalText': canonicalText,
      'contextTags': contextTags.toJson(),
      'usageCount': usageCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmojiMappingImpl extends EmojiMapping {
  _EmojiMappingImpl({
    int? id,
    required int personaId,
    _i2.Persona? persona,
    required String emojiSequence,
    required String canonicalText,
    required List<String> contextTags,
    int? usageCount,
    DateTime? createdAt,
  }) : super._(
         id: id,
         personaId: personaId,
         persona: persona,
         emojiSequence: emojiSequence,
         canonicalText: canonicalText,
         contextTags: contextTags,
         usageCount: usageCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EmojiMapping]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmojiMapping copyWith({
    Object? id = _Undefined,
    int? personaId,
    Object? persona = _Undefined,
    String? emojiSequence,
    String? canonicalText,
    List<String>? contextTags,
    int? usageCount,
    DateTime? createdAt,
  }) {
    return EmojiMapping(
      id: id is int? ? id : this.id,
      personaId: personaId ?? this.personaId,
      persona: persona is _i2.Persona? ? persona : this.persona?.copyWith(),
      emojiSequence: emojiSequence ?? this.emojiSequence,
      canonicalText: canonicalText ?? this.canonicalText,
      contextTags: contextTags ?? this.contextTags.map((e0) => e0).toList(),
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
