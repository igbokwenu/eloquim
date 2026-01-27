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
import 'conversation.dart' as _i2;
import 'emoji_combo.dart' as _i3;
import 'emoji_mapping.dart' as _i4;
import 'greetings/greeting.dart' as _i5;
import 'message.dart' as _i6;
import 'persona.dart' as _i7;
import 'recommendation_response.dart' as _i8;
import 'send_message_request.dart' as _i9;
import 'system_notification.dart' as _i10;
import 'token_call_entry.dart' as _i11;
import 'token_log.dart' as _i12;
import 'token_usage_info.dart' as _i13;
import 'user.dart' as _i14;
import 'package:eloquim_client/src/protocol/message.dart' as _i15;
import 'package:eloquim_client/src/protocol/conversation.dart' as _i16;
import 'package:eloquim_client/src/protocol/persona.dart' as _i17;
import 'package:eloquim_client/src/protocol/user.dart' as _i18;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i19;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i20;
export 'conversation.dart';
export 'emoji_combo.dart';
export 'emoji_mapping.dart';
export 'greetings/greeting.dart';
export 'message.dart';
export 'persona.dart';
export 'recommendation_response.dart';
export 'send_message_request.dart';
export 'system_notification.dart';
export 'token_call_entry.dart';
export 'token_log.dart';
export 'token_usage_info.dart';
export 'user.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Conversation) {
      return _i2.Conversation.fromJson(data) as T;
    }
    if (t == _i3.EmojiCombo) {
      return _i3.EmojiCombo.fromJson(data) as T;
    }
    if (t == _i4.EmojiMapping) {
      return _i4.EmojiMapping.fromJson(data) as T;
    }
    if (t == _i5.Greeting) {
      return _i5.Greeting.fromJson(data) as T;
    }
    if (t == _i6.Message) {
      return _i6.Message.fromJson(data) as T;
    }
    if (t == _i7.Persona) {
      return _i7.Persona.fromJson(data) as T;
    }
    if (t == _i8.RecommendationResponse) {
      return _i8.RecommendationResponse.fromJson(data) as T;
    }
    if (t == _i9.SendMessageRequest) {
      return _i9.SendMessageRequest.fromJson(data) as T;
    }
    if (t == _i10.SystemNotification) {
      return _i10.SystemNotification.fromJson(data) as T;
    }
    if (t == _i11.TokenCallEntry) {
      return _i11.TokenCallEntry.fromJson(data) as T;
    }
    if (t == _i12.TokenLog) {
      return _i12.TokenLog.fromJson(data) as T;
    }
    if (t == _i13.TokenUsageInfo) {
      return _i13.TokenUsageInfo.fromJson(data) as T;
    }
    if (t == _i14.User) {
      return _i14.User.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Conversation?>()) {
      return (data != null ? _i2.Conversation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.EmojiCombo?>()) {
      return (data != null ? _i3.EmojiCombo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.EmojiMapping?>()) {
      return (data != null ? _i4.EmojiMapping.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Greeting?>()) {
      return (data != null ? _i5.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Message?>()) {
      return (data != null ? _i6.Message.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Persona?>()) {
      return (data != null ? _i7.Persona.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.RecommendationResponse?>()) {
      return (data != null ? _i8.RecommendationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.SendMessageRequest?>()) {
      return (data != null ? _i9.SendMessageRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.SystemNotification?>()) {
      return (data != null ? _i10.SystemNotification.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.TokenCallEntry?>()) {
      return (data != null ? _i11.TokenCallEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.TokenLog?>()) {
      return (data != null ? _i12.TokenLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.TokenUsageInfo?>()) {
      return (data != null ? _i13.TokenUsageInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.User?>()) {
      return (data != null ? _i14.User.fromJson(data) : null) as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i3.EmojiCombo>) {
      return (data as List).map((e) => deserialize<_i3.EmojiCombo>(e)).toList()
          as T;
    }
    if (t == List<_i11.TokenCallEntry>) {
      return (data as List)
              .map((e) => deserialize<_i11.TokenCallEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i15.Message>) {
      return (data as List).map((e) => deserialize<_i15.Message>(e)).toList()
          as T;
    }
    if (t == List<_i16.Conversation>) {
      return (data as List)
              .map((e) => deserialize<_i16.Conversation>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i17.Persona>) {
      return (data as List).map((e) => deserialize<_i17.Persona>(e)).toList()
          as T;
    }
    if (t == List<_i18.User>) {
      return (data as List).map((e) => deserialize<_i18.User>(e)).toList() as T;
    }
    try {
      return _i19.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i20.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Conversation => 'Conversation',
      _i3.EmojiCombo => 'EmojiCombo',
      _i4.EmojiMapping => 'EmojiMapping',
      _i5.Greeting => 'Greeting',
      _i6.Message => 'Message',
      _i7.Persona => 'Persona',
      _i8.RecommendationResponse => 'RecommendationResponse',
      _i9.SendMessageRequest => 'SendMessageRequest',
      _i10.SystemNotification => 'SystemNotification',
      _i11.TokenCallEntry => 'TokenCallEntry',
      _i12.TokenLog => 'TokenLog',
      _i13.TokenUsageInfo => 'TokenUsageInfo',
      _i14.User => 'User',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('eloquim.', '');
    }

    switch (data) {
      case _i2.Conversation():
        return 'Conversation';
      case _i3.EmojiCombo():
        return 'EmojiCombo';
      case _i4.EmojiMapping():
        return 'EmojiMapping';
      case _i5.Greeting():
        return 'Greeting';
      case _i6.Message():
        return 'Message';
      case _i7.Persona():
        return 'Persona';
      case _i8.RecommendationResponse():
        return 'RecommendationResponse';
      case _i9.SendMessageRequest():
        return 'SendMessageRequest';
      case _i10.SystemNotification():
        return 'SystemNotification';
      case _i11.TokenCallEntry():
        return 'TokenCallEntry';
      case _i12.TokenLog():
        return 'TokenLog';
      case _i13.TokenUsageInfo():
        return 'TokenUsageInfo';
      case _i14.User():
        return 'User';
    }
    className = _i19.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i20.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Conversation') {
      return deserialize<_i2.Conversation>(data['data']);
    }
    if (dataClassName == 'EmojiCombo') {
      return deserialize<_i3.EmojiCombo>(data['data']);
    }
    if (dataClassName == 'EmojiMapping') {
      return deserialize<_i4.EmojiMapping>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i5.Greeting>(data['data']);
    }
    if (dataClassName == 'Message') {
      return deserialize<_i6.Message>(data['data']);
    }
    if (dataClassName == 'Persona') {
      return deserialize<_i7.Persona>(data['data']);
    }
    if (dataClassName == 'RecommendationResponse') {
      return deserialize<_i8.RecommendationResponse>(data['data']);
    }
    if (dataClassName == 'SendMessageRequest') {
      return deserialize<_i9.SendMessageRequest>(data['data']);
    }
    if (dataClassName == 'SystemNotification') {
      return deserialize<_i10.SystemNotification>(data['data']);
    }
    if (dataClassName == 'TokenCallEntry') {
      return deserialize<_i11.TokenCallEntry>(data['data']);
    }
    if (dataClassName == 'TokenLog') {
      return deserialize<_i12.TokenLog>(data['data']);
    }
    if (dataClassName == 'TokenUsageInfo') {
      return deserialize<_i13.TokenUsageInfo>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i14.User>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i19.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i20.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i19.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i20.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
