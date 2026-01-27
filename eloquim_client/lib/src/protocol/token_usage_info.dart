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
import 'token_call_entry.dart' as _i2;
import 'package:eloquim_client/src/protocol/protocol.dart' as _i3;

abstract class TokenUsageInfo implements _i1.SerializableModel {
  TokenUsageInfo._({
    required this.totalTokens,
    required this.lastCalls,
  });

  factory TokenUsageInfo({
    required int totalTokens,
    required List<_i2.TokenCallEntry> lastCalls,
  }) = _TokenUsageInfoImpl;

  factory TokenUsageInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return TokenUsageInfo(
      totalTokens: jsonSerialization['totalTokens'] as int,
      lastCalls: _i3.Protocol().deserialize<List<_i2.TokenCallEntry>>(
        jsonSerialization['lastCalls'],
      ),
    );
  }

  int totalTokens;

  List<_i2.TokenCallEntry> lastCalls;

  /// Returns a shallow copy of this [TokenUsageInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TokenUsageInfo copyWith({
    int? totalTokens,
    List<_i2.TokenCallEntry>? lastCalls,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TokenUsageInfo',
      'totalTokens': totalTokens,
      'lastCalls': lastCalls.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TokenUsageInfoImpl extends TokenUsageInfo {
  _TokenUsageInfoImpl({
    required int totalTokens,
    required List<_i2.TokenCallEntry> lastCalls,
  }) : super._(
         totalTokens: totalTokens,
         lastCalls: lastCalls,
       );

  /// Returns a shallow copy of this [TokenUsageInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TokenUsageInfo copyWith({
    int? totalTokens,
    List<_i2.TokenCallEntry>? lastCalls,
  }) {
    return TokenUsageInfo(
      totalTokens: totalTokens ?? this.totalTokens,
      lastCalls:
          lastCalls ?? this.lastCalls.map((e0) => e0.copyWith()).toList(),
    );
  }
}
