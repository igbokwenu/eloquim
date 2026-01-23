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

abstract class EmojiCombo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  EmojiCombo._({
    required this.emojis,
    required this.meaning,
  });

  factory EmojiCombo({
    required List<String> emojis,
    required String meaning,
  }) = _EmojiComboImpl;

  factory EmojiCombo.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmojiCombo(
      emojis: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['emojis'],
      ),
      meaning: jsonSerialization['meaning'] as String,
    );
  }

  List<String> emojis;

  String meaning;

  /// Returns a shallow copy of this [EmojiCombo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmojiCombo copyWith({
    List<String>? emojis,
    String? meaning,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmojiCombo',
      'emojis': emojis.toJson(),
      'meaning': meaning,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EmojiCombo',
      'emojis': emojis.toJson(),
      'meaning': meaning,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EmojiComboImpl extends EmojiCombo {
  _EmojiComboImpl({
    required List<String> emojis,
    required String meaning,
  }) : super._(
         emojis: emojis,
         meaning: meaning,
       );

  /// Returns a shallow copy of this [EmojiCombo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmojiCombo copyWith({
    List<String>? emojis,
    String? meaning,
  }) {
    return EmojiCombo(
      emojis: emojis ?? this.emojis.map((e0) => e0).toList(),
      meaning: meaning ?? this.meaning,
    );
  }
}
