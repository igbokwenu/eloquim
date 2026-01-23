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
import 'emoji_combo.dart' as _i2;
import 'package:eloquim_server/src/generated/protocol.dart' as _i3;

abstract class RecommendationResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RecommendationResponse._({
    required this.singles,
    required this.combos,
  });

  factory RecommendationResponse({
    required List<String> singles,
    required List<_i2.EmojiCombo> combos,
  }) = _RecommendationResponseImpl;

  factory RecommendationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RecommendationResponse(
      singles: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['singles'],
      ),
      combos: _i3.Protocol().deserialize<List<_i2.EmojiCombo>>(
        jsonSerialization['combos'],
      ),
    );
  }

  List<String> singles;

  List<_i2.EmojiCombo> combos;

  /// Returns a shallow copy of this [RecommendationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RecommendationResponse copyWith({
    List<String>? singles,
    List<_i2.EmojiCombo>? combos,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecommendationResponse',
      'singles': singles.toJson(),
      'combos': combos.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecommendationResponse',
      'singles': singles.toJson(),
      'combos': combos.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RecommendationResponseImpl extends RecommendationResponse {
  _RecommendationResponseImpl({
    required List<String> singles,
    required List<_i2.EmojiCombo> combos,
  }) : super._(
         singles: singles,
         combos: combos,
       );

  /// Returns a shallow copy of this [RecommendationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RecommendationResponse copyWith({
    List<String>? singles,
    List<_i2.EmojiCombo>? combos,
  }) {
    return RecommendationResponse(
      singles: singles ?? this.singles.map((e0) => e0).toList(),
      combos: combos ?? this.combos.map((e0) => e0.copyWith()).toList(),
    );
  }
}
