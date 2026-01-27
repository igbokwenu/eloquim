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

abstract class TokenCallEntry implements _i1.SerializableModel {
  TokenCallEntry._({
    required this.tokens,
    required this.cost,
    required this.type,
    required this.time,
  });

  factory TokenCallEntry({
    required int tokens,
    required double cost,
    required String type,
    required DateTime time,
  }) = _TokenCallEntryImpl;

  factory TokenCallEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return TokenCallEntry(
      tokens: jsonSerialization['tokens'] as int,
      cost: (jsonSerialization['cost'] as num).toDouble(),
      type: jsonSerialization['type'] as String,
      time: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
    );
  }

  int tokens;

  double cost;

  String type;

  DateTime time;

  /// Returns a shallow copy of this [TokenCallEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TokenCallEntry copyWith({
    int? tokens,
    double? cost,
    String? type,
    DateTime? time,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TokenCallEntry',
      'tokens': tokens,
      'cost': cost,
      'type': type,
      'time': time.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TokenCallEntryImpl extends TokenCallEntry {
  _TokenCallEntryImpl({
    required int tokens,
    required double cost,
    required String type,
    required DateTime time,
  }) : super._(
         tokens: tokens,
         cost: cost,
         type: type,
         time: time,
       );

  /// Returns a shallow copy of this [TokenCallEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TokenCallEntry copyWith({
    int? tokens,
    double? cost,
    String? type,
    DateTime? time,
  }) {
    return TokenCallEntry(
      tokens: tokens ?? this.tokens,
      cost: cost ?? this.cost,
      type: type ?? this.type,
      time: time ?? this.time,
    );
  }
}
