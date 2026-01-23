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
import 'conversation.dart' as _i2;
import 'package:eloquim_server/src/generated/protocol.dart' as _i3;

abstract class SystemNotification
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SystemNotification._({
    required this.type,
    this.conversation,
  });

  factory SystemNotification({
    required String type,
    _i2.Conversation? conversation,
  }) = _SystemNotificationImpl;

  factory SystemNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return SystemNotification(
      type: jsonSerialization['type'] as String,
      conversation: jsonSerialization['conversation'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Conversation>(
              jsonSerialization['conversation'],
            ),
    );
  }

  String type;

  _i2.Conversation? conversation;

  /// Returns a shallow copy of this [SystemNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SystemNotification copyWith({
    String? type,
    _i2.Conversation? conversation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SystemNotification',
      'type': type,
      if (conversation != null) 'conversation': conversation?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SystemNotification',
      'type': type,
      if (conversation != null)
        'conversation': conversation?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SystemNotificationImpl extends SystemNotification {
  _SystemNotificationImpl({
    required String type,
    _i2.Conversation? conversation,
  }) : super._(
         type: type,
         conversation: conversation,
       );

  /// Returns a shallow copy of this [SystemNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SystemNotification copyWith({
    String? type,
    Object? conversation = _Undefined,
  }) {
    return SystemNotification(
      type: type ?? this.type,
      conversation: conversation is _i2.Conversation?
          ? conversation
          : this.conversation?.copyWith(),
    );
  }
}
