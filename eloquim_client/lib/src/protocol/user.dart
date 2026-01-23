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

abstract class User implements _i1.SerializableModel {
  User._({
    this.id,
    required this.username,
    this.email,
    this.gender,
    this.age,
    this.country,
    required this.personaId,
    this.persona,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  }) : emojiSignature = emojiSignature ?? '✨🎵💫',
       hasDoneTutorial = hasDoneTutorial ?? false,
       createdAt = createdAt ?? DateTime.now(),
       lastSeen = lastSeen ?? DateTime.now(),
       isAnonymous = isAnonymous ?? true;

  factory User({
    int? id,
    required String username,
    String? email,
    String? gender,
    int? age,
    String? country,
    required int personaId,
    _i2.Persona? persona,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] as int?,
      username: jsonSerialization['username'] as String,
      email: jsonSerialization['email'] as String?,
      gender: jsonSerialization['gender'] as String?,
      age: jsonSerialization['age'] as int?,
      country: jsonSerialization['country'] as String?,
      personaId: jsonSerialization['personaId'] as int,
      persona: jsonSerialization['persona'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Persona>(
              jsonSerialization['persona'],
            ),
      emojiSignature: jsonSerialization['emojiSignature'] as String?,
      hasDoneTutorial: jsonSerialization['hasDoneTutorial'] as bool?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastSeen: jsonSerialization['lastSeen'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeen']),
      isAnonymous: jsonSerialization['isAnonymous'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String username;

  String? email;

  String? gender;

  int? age;

  String? country;

  int personaId;

  _i2.Persona? persona;

  String emojiSignature;

  bool hasDoneTutorial;

  DateTime createdAt;

  DateTime lastSeen;

  bool isAnonymous;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? gender,
    int? age,
    String? country,
    int? personaId,
    _i2.Persona? persona,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id,
      'username': username,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (country != null) 'country': country,
      'personaId': personaId,
      if (persona != null) 'persona': persona?.toJson(),
      'emojiSignature': emojiSignature,
      'hasDoneTutorial': hasDoneTutorial,
      'createdAt': createdAt.toJson(),
      'lastSeen': lastSeen.toJson(),
      'isAnonymous': isAnonymous,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserImpl extends User {
  _UserImpl({
    int? id,
    required String username,
    String? email,
    String? gender,
    int? age,
    String? country,
    required int personaId,
    _i2.Persona? persona,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  }) : super._(
         id: id,
         username: username,
         email: email,
         gender: gender,
         age: age,
         country: country,
         personaId: personaId,
         persona: persona,
         emojiSignature: emojiSignature,
         hasDoneTutorial: hasDoneTutorial,
         createdAt: createdAt,
         lastSeen: lastSeen,
         isAnonymous: isAnonymous,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    String? username,
    Object? email = _Undefined,
    Object? gender = _Undefined,
    Object? age = _Undefined,
    Object? country = _Undefined,
    int? personaId,
    Object? persona = _Undefined,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  }) {
    return User(
      id: id is int? ? id : this.id,
      username: username ?? this.username,
      email: email is String? ? email : this.email,
      gender: gender is String? ? gender : this.gender,
      age: age is int? ? age : this.age,
      country: country is String? ? country : this.country,
      personaId: personaId ?? this.personaId,
      persona: persona is _i2.Persona? ? persona : this.persona?.copyWith(),
      emojiSignature: emojiSignature ?? this.emojiSignature,
      hasDoneTutorial: hasDoneTutorial ?? this.hasDoneTutorial,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
