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
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:eloquim_client/src/protocol/message.dart' as _i5;
import 'package:eloquim_client/src/protocol/send_message_request.dart' as _i6;
import 'package:eloquim_client/src/protocol/conversation.dart' as _i7;
import 'package:eloquim_client/src/protocol/system_notification.dart' as _i8;
import 'package:eloquim_client/src/protocol/persona.dart' as _i9;
import 'package:eloquim_client/src/protocol/recommendation_response.dart'
    as _i10;
import 'package:eloquim_client/src/protocol/user.dart' as _i11;
import 'package:eloquim_client/src/protocol/token_usage_info.dart' as _i12;
import 'package:eloquim_client/src/protocol/greetings/greeting.dart' as _i13;
import 'protocol.dart' as _i14;

/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// {@category Endpoint}
class EndpointChat extends _i2.EndpointRef {
  EndpointChat(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'chat';

  /// Send a message with emoji translation
  _i3.Future<_i5.Message> sendMessage(_i6.SendMessageRequest request) =>
      caller.callServerEndpoint<_i5.Message>(
        'chat',
        'sendMessage',
        {'request': request},
      );

  /// Stream messages for real-time chat
  _i3.Stream<_i5.Message> streamChat(int conversationId) =>
      caller.callStreamingServerEndpoint<_i3.Stream<_i5.Message>, _i5.Message>(
        'chat',
        'streamChat',
        {'conversationId': conversationId},
        {},
      );

  /// Get recent messages
  _i3.Future<List<_i5.Message>> getMessages(
    int conversationId, {
    required int limit,
    DateTime? before,
  }) => caller.callServerEndpoint<List<_i5.Message>>(
    'chat',
    'getMessages',
    {
      'conversationId': conversationId,
      'limit': limit,
      'before': before,
    },
  );

  /// Mark messages as read
  _i3.Future<void> markAsRead(
    int conversationId,
    int messageId,
  ) => caller.callServerEndpoint<void>(
    'chat',
    'markAsRead',
    {
      'conversationId': conversationId,
      'messageId': messageId,
    },
  );
}

/// {@category Endpoint}
class EndpointConversation extends _i2.EndpointRef {
  EndpointConversation(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'conversation';

  /// Get all conversations for current user
  _i3.Future<List<_i7.Conversation>> getConversations() =>
      caller.callServerEndpoint<List<_i7.Conversation>>(
        'conversation',
        'getConversations',
        {},
      );

  /// Create a new conversation
  _i3.Future<_i7.Conversation> createConversation(
    List<int> participantIds,
    String? title,
  ) => caller.callServerEndpoint<_i7.Conversation>(
    'conversation',
    'createConversation',
    {
      'participantIds': participantIds,
      'title': title,
    },
  );

  /// Get conversation details
  _i3.Future<_i7.Conversation?> getConversation(int conversationId) =>
      caller.callServerEndpoint<_i7.Conversation?>(
        'conversation',
        'getConversation',
        {'conversationId': conversationId},
      );

  /// Archive a conversation
  _i3.Future<void> archiveConversation(int conversationId) =>
      caller.callServerEndpoint<void>(
        'conversation',
        'archiveConversation',
        {'conversationId': conversationId},
      );

  /// Delete a conversation
  _i3.Future<void> deleteConversation(int conversationId) =>
      caller.callServerEndpoint<void>(
        'conversation',
        'deleteConversation',
        {'conversationId': conversationId},
      );

  /// Listen for system notifications (e.g. new conversations)
  _i3.Stream<_i8.SystemNotification> listenToSystemNotifications() =>
      caller.callStreamingServerEndpoint<
        _i3.Stream<_i8.SystemNotification>,
        _i8.SystemNotification
      >(
        'conversation',
        'listenToSystemNotifications',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointPersona extends _i2.EndpointRef {
  EndpointPersona(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'persona';

  _i3.Future<List<_i9.Persona>> getOfficialPersonas() =>
      caller.callServerEndpoint<List<_i9.Persona>>(
        'persona',
        'getOfficialPersonas',
        {},
      );

  _i3.Future<_i9.Persona?> getPersona(int personaId) =>
      caller.callServerEndpoint<_i9.Persona?>(
        'persona',
        'getPersona',
        {'personaId': personaId},
      );

  _i3.Future<void> seedOfficialPersonas() => caller.callServerEndpoint<void>(
    'persona',
    'seedOfficialPersonas',
    {},
  );

  _i3.Future<void> assignPersona(int personaId) =>
      caller.callServerEndpoint<void>(
        'persona',
        'assignPersona',
        {'personaId': personaId},
      );
}

/// {@category Endpoint}
class EndpointRecommendation extends _i2.EndpointRef {
  EndpointRecommendation(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recommendation';

  _i3.Future<_i10.RecommendationResponse> getRecommendations(
    int conversationId,
    String partialText,
    String tone,
    String personaId,
  ) => caller.callServerEndpoint<_i10.RecommendationResponse>(
    'recommendation',
    'getRecommendations',
    {
      'conversationId': conversationId,
      'partialText': partialText,
      'tone': tone,
      'personaId': personaId,
    },
  );
}

/// {@category Endpoint}
class EndpointRefreshJwtTokens extends _i4.EndpointRefreshJwtTokens {
  EndpointRefreshJwtTokens(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'refreshJwtTokens';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'refreshJwtTokens',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointUser extends _i2.EndpointRef {
  EndpointUser(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i3.Future<_i11.User?> getCurrentUser() =>
      caller.callServerEndpoint<_i11.User?>(
        'user',
        'getCurrentUser',
        {},
      );

  _i3.Future<_i11.User> updateProfile({
    String? username,
    String? gender,
    int? age,
    String? country,
  }) => caller.callServerEndpoint<_i11.User>(
    'user',
    'updateProfile',
    {
      'username': username,
      'gender': gender,
      'age': age,
      'country': country,
    },
  );

  _i3.Future<void> completeTutorial() => caller.callServerEndpoint<void>(
    'user',
    'completeTutorial',
    {},
  );

  _i3.Future<_i11.User?> getUser(int userId) =>
      caller.callServerEndpoint<_i11.User?>(
        'user',
        'getUser',
        {'userId': userId},
      );

  _i3.Future<void> updateLastSeen() => caller.callServerEndpoint<void>(
    'user',
    'updateLastSeen',
    {},
  );

  _i3.Future<List<_i11.User>> findMatches({
    int? minAge,
    int? maxAge,
    String? country,
    required int limit,
  }) => caller.callServerEndpoint<List<_i11.User>>(
    'user',
    'findMatches',
    {
      'minAge': minAge,
      'maxAge': maxAge,
      'country': country,
      'limit': limit,
    },
  );

  /// Deletes the user account and all associated data.
  _i3.Future<void> deleteAccount() => caller.callServerEndpoint<void>(
    'user',
    'deleteAccount',
    {},
  );

  /// Seed initial bots if they don't exist
  _i3.Future<void> seedBots() => caller.callServerEndpoint<void>(
    'user',
    'seedBots',
    {},
  );

  /// Logs token usage for a user
  _i3.Future<void> logTokenUsage({
    required int userId,
    required int tokenCount,
    required String apiCallType,
  }) => caller.callServerEndpoint<void>(
    'user',
    'logTokenUsage',
    {
      'userId': userId,
      'tokenCount': tokenCount,
      'apiCallType': apiCallType,
    },
  );

  /// Gets token usage info for the current user
  _i3.Future<_i12.TokenUsageInfo> getTokenUsageInfo() =>
      caller.callServerEndpoint<_i12.TokenUsageInfo>(
        'user',
        'getTokenUsageInfo',
        {},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i13.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i13.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i14.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    chat = EndpointChat(this);
    conversation = EndpointConversation(this);
    persona = EndpointPersona(this);
    recommendation = EndpointRecommendation(this);
    refreshJwtTokens = EndpointRefreshJwtTokens(this);
    user = EndpointUser(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointChat chat;

  late final EndpointConversation conversation;

  late final EndpointPersona persona;

  late final EndpointRecommendation recommendation;

  late final EndpointRefreshJwtTokens refreshJwtTokens;

  late final EndpointUser user;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'chat': chat,
    'conversation': conversation,
    'persona': persona,
    'recommendation': recommendation,
    'refreshJwtTokens': refreshJwtTokens,
    'user': user,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
