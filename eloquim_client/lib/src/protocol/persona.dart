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
import 'user.dart' as _i2;
import 'package:eloquim_client/src/protocol/protocol.dart' as _i3;

abstract class Persona implements _i1.SerializableModel {
  Persona._({
    this.id,
    required this.name,
    this.creatorId,
    this.creator,
    bool? isOfficial,
    required this.description,
    required this.traitsJson,
    required this.communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  }) : isOfficial = isOfficial ?? false,
       packVersion = packVersion ?? '1.0',
       createdAt = createdAt ?? DateTime.now();

  factory Persona({
    int? id,
    required String name,
    int? creatorId,
    _i2.User? creator,
    bool? isOfficial,
    required String description,
    required String traitsJson,
    required String communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  }) = _PersonaImpl;

  factory Persona.fromJson(Map<String, dynamic> jsonSerialization) {
    return Persona(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      creatorId: jsonSerialization['creatorId'] as int?,
      creator: jsonSerialization['creator'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['creator']),
      isOfficial: jsonSerialization['isOfficial'] as bool?,
      description: jsonSerialization['description'] as String,
      traitsJson: jsonSerialization['traitsJson'] as String,
      communicationStyle: jsonSerialization['communicationStyle'] as String,
      packVersion: jsonSerialization['packVersion'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? creatorId;

  _i2.User? creator;

  bool isOfficial;

  String description;

  String traitsJson;

  String communicationStyle;

  String packVersion;

  DateTime createdAt;

  /// Returns a shallow copy of this [Persona]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Persona copyWith({
    int? id,
    String? name,
    int? creatorId,
    _i2.User? creator,
    bool? isOfficial,
    String? description,
    String? traitsJson,
    String? communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Persona',
      if (id != null) 'id': id,
      'name': name,
      if (creatorId != null) 'creatorId': creatorId,
      if (creator != null) 'creator': creator?.toJson(),
      'isOfficial': isOfficial,
      'description': description,
      'traitsJson': traitsJson,
      'communicationStyle': communicationStyle,
      'packVersion': packVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PersonaImpl extends Persona {
  _PersonaImpl({
    int? id,
    required String name,
    int? creatorId,
    _i2.User? creator,
    bool? isOfficial,
    required String description,
    required String traitsJson,
    required String communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         creatorId: creatorId,
         creator: creator,
         isOfficial: isOfficial,
         description: description,
         traitsJson: traitsJson,
         communicationStyle: communicationStyle,
         packVersion: packVersion,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Persona]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Persona copyWith({
    Object? id = _Undefined,
    String? name,
    Object? creatorId = _Undefined,
    Object? creator = _Undefined,
    bool? isOfficial,
    String? description,
    String? traitsJson,
    String? communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  }) {
    return Persona(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      creatorId: creatorId is int? ? creatorId : this.creatorId,
      creator: creator is _i2.User? ? creator : this.creator?.copyWith(),
      isOfficial: isOfficial ?? this.isOfficial,
      description: description ?? this.description,
      traitsJson: traitsJson ?? this.traitsJson,
      communicationStyle: communicationStyle ?? this.communicationStyle,
      packVersion: packVersion ?? this.packVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
