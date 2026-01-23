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
import 'package:eloquim_client/src/protocol/protocol.dart' as _i2;

abstract class Conversation implements _i1.SerializableModel {
  Conversation._({
    this.id,
    String? type,
    this.title,
    required this.participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    this.chemistryScore,
    String? status,
  }) : type = type ?? 'p2p',
       startedAt = startedAt ?? DateTime.now(),
       lastMessageAt = lastMessageAt ?? DateTime.now(),
       status = status ?? 'active';

  factory Conversation({
    int? id,
    String? type,
    String? title,
    required List<int> participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    double? chemistryScore,
    String? status,
  }) = _ConversationImpl;

  factory Conversation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Conversation(
      id: jsonSerialization['id'] as int?,
      type: jsonSerialization['type'] as String?,
      title: jsonSerialization['title'] as String?,
      participantIds: _i2.Protocol().deserialize<List<int>>(
        jsonSerialization['participantIds'],
      ),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      lastMessageAt: jsonSerialization['lastMessageAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageAt'],
            ),
      chemistryScore: (jsonSerialization['chemistryScore'] as num?)?.toDouble(),
      status: jsonSerialization['status'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String type;

  String? title;

  List<int> participantIds;

  DateTime startedAt;

  DateTime lastMessageAt;

  double? chemistryScore;

  String status;

  /// Returns a shallow copy of this [Conversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Conversation copyWith({
    int? id,
    String? type,
    String? title,
    List<int>? participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    double? chemistryScore,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Conversation',
      if (id != null) 'id': id,
      'type': type,
      if (title != null) 'title': title,
      'participantIds': participantIds.toJson(),
      'startedAt': startedAt.toJson(),
      'lastMessageAt': lastMessageAt.toJson(),
      if (chemistryScore != null) 'chemistryScore': chemistryScore,
      'status': status,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConversationImpl extends Conversation {
  _ConversationImpl({
    int? id,
    String? type,
    String? title,
    required List<int> participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    double? chemistryScore,
    String? status,
  }) : super._(
         id: id,
         type: type,
         title: title,
         participantIds: participantIds,
         startedAt: startedAt,
         lastMessageAt: lastMessageAt,
         chemistryScore: chemistryScore,
         status: status,
       );

  /// Returns a shallow copy of this [Conversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Conversation copyWith({
    Object? id = _Undefined,
    String? type,
    Object? title = _Undefined,
    List<int>? participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    Object? chemistryScore = _Undefined,
    String? status,
  }) {
    return Conversation(
      id: id is int? ? id : this.id,
      type: type ?? this.type,
      title: title is String? ? title : this.title,
      participantIds:
          participantIds ?? this.participantIds.map((e0) => e0).toList(),
      startedAt: startedAt ?? this.startedAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      chemistryScore: chemistryScore is double?
          ? chemistryScore
          : this.chemistryScore,
      status: status ?? this.status,
    );
  }
}
