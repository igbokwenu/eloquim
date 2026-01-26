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

abstract class TokenLog implements _i1.SerializableModel {
  TokenLog._({
    this.id,
    required this.userId,
    required this.tokenCount,
    required this.estimatedCost,
    required this.apiCallType,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory TokenLog({
    int? id,
    required int userId,
    required int tokenCount,
    required double estimatedCost,
    required String apiCallType,
    DateTime? timestamp,
  }) = _TokenLogImpl;

  factory TokenLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return TokenLog(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      tokenCount: jsonSerialization['tokenCount'] as int,
      estimatedCost: (jsonSerialization['estimatedCost'] as num).toDouble(),
      apiCallType: jsonSerialization['apiCallType'] as String,
      timestamp: jsonSerialization['timestamp'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  int tokenCount;

  double estimatedCost;

  String apiCallType;

  DateTime timestamp;

  /// Returns a shallow copy of this [TokenLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TokenLog copyWith({
    int? id,
    int? userId,
    int? tokenCount,
    double? estimatedCost,
    String? apiCallType,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TokenLog',
      if (id != null) 'id': id,
      'userId': userId,
      'tokenCount': tokenCount,
      'estimatedCost': estimatedCost,
      'apiCallType': apiCallType,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TokenLogImpl extends TokenLog {
  _TokenLogImpl({
    int? id,
    required int userId,
    required int tokenCount,
    required double estimatedCost,
    required String apiCallType,
    DateTime? timestamp,
  }) : super._(
         id: id,
         userId: userId,
         tokenCount: tokenCount,
         estimatedCost: estimatedCost,
         apiCallType: apiCallType,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [TokenLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TokenLog copyWith({
    Object? id = _Undefined,
    int? userId,
    int? tokenCount,
    double? estimatedCost,
    String? apiCallType,
    DateTime? timestamp,
  }) {
    return TokenLog(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      tokenCount: tokenCount ?? this.tokenCount,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      apiCallType: apiCallType ?? this.apiCallType,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
