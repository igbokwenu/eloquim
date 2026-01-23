/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'conversation.dart' as _i2;
import 'user.dart' as _i3;
import 'package:eloquim_server/src/generated/protocol.dart' as _i4;

abstract class Message
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Message._({
    this.id,
    required this.conversationId,
    this.conversation,
    required this.senderId,
    this.sender,
    required this.emojiSequence,
    this.rawIntent,
    required this.translatedText,
    String? tone,
    required this.personaUsed,
    double? confidenceScore,
    this.mediaGifUrl,
    this.replyToMsgId,
    DateTime? createdAt,
    this.deliveredAt,
    this.readAt,
    bool? isEncrypted,
  }) : tone = tone ?? 'casual',
       confidenceScore = confidenceScore ?? 0.0,
       createdAt = createdAt ?? DateTime.now(),
       isEncrypted = isEncrypted ?? false;

  factory Message({
    int? id,
    required int conversationId,
    _i2.Conversation? conversation,
    required int senderId,
    _i3.User? sender,
    required List<String> emojiSequence,
    String? rawIntent,
    required String translatedText,
    String? tone,
    required String personaUsed,
    double? confidenceScore,
    String? mediaGifUrl,
    int? replyToMsgId,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    bool? isEncrypted,
  }) = _MessageImpl;

  factory Message.fromJson(Map<String, dynamic> jsonSerialization) {
    return Message(
      id: jsonSerialization['id'] as int?,
      conversationId: jsonSerialization['conversationId'] as int,
      conversation: jsonSerialization['conversation'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Conversation>(
              jsonSerialization['conversation'],
            ),
      senderId: jsonSerialization['senderId'] as int,
      sender: jsonSerialization['sender'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.User>(jsonSerialization['sender']),
      emojiSequence: _i4.Protocol().deserialize<List<String>>(
        jsonSerialization['emojiSequence'],
      ),
      rawIntent: jsonSerialization['rawIntent'] as String?,
      translatedText: jsonSerialization['translatedText'] as String,
      tone: jsonSerialization['tone'] as String?,
      personaUsed: jsonSerialization['personaUsed'] as String,
      confidenceScore: (jsonSerialization['confidenceScore'] as num?)
          ?.toDouble(),
      mediaGifUrl: jsonSerialization['mediaGifUrl'] as String?,
      replyToMsgId: jsonSerialization['replyToMsgId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      isEncrypted: jsonSerialization['isEncrypted'] as bool?,
    );
  }

  static final t = MessageTable();

  static const db = MessageRepository._();

  @override
  int? id;

  int conversationId;

  _i2.Conversation? conversation;

  int senderId;

  _i3.User? sender;

  List<String> emojiSequence;

  String? rawIntent;

  String translatedText;

  String tone;

  String personaUsed;

  double confidenceScore;

  String? mediaGifUrl;

  int? replyToMsgId;

  DateTime createdAt;

  DateTime? deliveredAt;

  DateTime? readAt;

  bool isEncrypted;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Message]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Message copyWith({
    int? id,
    int? conversationId,
    _i2.Conversation? conversation,
    int? senderId,
    _i3.User? sender,
    List<String>? emojiSequence,
    String? rawIntent,
    String? translatedText,
    String? tone,
    String? personaUsed,
    double? confidenceScore,
    String? mediaGifUrl,
    int? replyToMsgId,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    bool? isEncrypted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Message',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      if (conversation != null) 'conversation': conversation?.toJson(),
      'senderId': senderId,
      if (sender != null) 'sender': sender?.toJson(),
      'emojiSequence': emojiSequence.toJson(),
      if (rawIntent != null) 'rawIntent': rawIntent,
      'translatedText': translatedText,
      'tone': tone,
      'personaUsed': personaUsed,
      'confidenceScore': confidenceScore,
      if (mediaGifUrl != null) 'mediaGifUrl': mediaGifUrl,
      if (replyToMsgId != null) 'replyToMsgId': replyToMsgId,
      'createdAt': createdAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      'isEncrypted': isEncrypted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Message',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      if (conversation != null)
        'conversation': conversation?.toJsonForProtocol(),
      'senderId': senderId,
      if (sender != null) 'sender': sender?.toJsonForProtocol(),
      'emojiSequence': emojiSequence.toJson(),
      if (rawIntent != null) 'rawIntent': rawIntent,
      'translatedText': translatedText,
      'tone': tone,
      'personaUsed': personaUsed,
      'confidenceScore': confidenceScore,
      if (mediaGifUrl != null) 'mediaGifUrl': mediaGifUrl,
      if (replyToMsgId != null) 'replyToMsgId': replyToMsgId,
      'createdAt': createdAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      'isEncrypted': isEncrypted,
    };
  }

  static MessageInclude include({
    _i2.ConversationInclude? conversation,
    _i3.UserInclude? sender,
  }) {
    return MessageInclude._(
      conversation: conversation,
      sender: sender,
    );
  }

  static MessageIncludeList includeList({
    _i1.WhereExpressionBuilder<MessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MessageTable>? orderByList,
    MessageInclude? include,
  }) {
    return MessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Message.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Message.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MessageImpl extends Message {
  _MessageImpl({
    int? id,
    required int conversationId,
    _i2.Conversation? conversation,
    required int senderId,
    _i3.User? sender,
    required List<String> emojiSequence,
    String? rawIntent,
    required String translatedText,
    String? tone,
    required String personaUsed,
    double? confidenceScore,
    String? mediaGifUrl,
    int? replyToMsgId,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    bool? isEncrypted,
  }) : super._(
         id: id,
         conversationId: conversationId,
         conversation: conversation,
         senderId: senderId,
         sender: sender,
         emojiSequence: emojiSequence,
         rawIntent: rawIntent,
         translatedText: translatedText,
         tone: tone,
         personaUsed: personaUsed,
         confidenceScore: confidenceScore,
         mediaGifUrl: mediaGifUrl,
         replyToMsgId: replyToMsgId,
         createdAt: createdAt,
         deliveredAt: deliveredAt,
         readAt: readAt,
         isEncrypted: isEncrypted,
       );

  /// Returns a shallow copy of this [Message]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Message copyWith({
    Object? id = _Undefined,
    int? conversationId,
    Object? conversation = _Undefined,
    int? senderId,
    Object? sender = _Undefined,
    List<String>? emojiSequence,
    Object? rawIntent = _Undefined,
    String? translatedText,
    String? tone,
    String? personaUsed,
    double? confidenceScore,
    Object? mediaGifUrl = _Undefined,
    Object? replyToMsgId = _Undefined,
    DateTime? createdAt,
    Object? deliveredAt = _Undefined,
    Object? readAt = _Undefined,
    bool? isEncrypted,
  }) {
    return Message(
      id: id is int? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation is _i2.Conversation?
          ? conversation
          : this.conversation?.copyWith(),
      senderId: senderId ?? this.senderId,
      sender: sender is _i3.User? ? sender : this.sender?.copyWith(),
      emojiSequence:
          emojiSequence ?? this.emojiSequence.map((e0) => e0).toList(),
      rawIntent: rawIntent is String? ? rawIntent : this.rawIntent,
      translatedText: translatedText ?? this.translatedText,
      tone: tone ?? this.tone,
      personaUsed: personaUsed ?? this.personaUsed,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      mediaGifUrl: mediaGifUrl is String? ? mediaGifUrl : this.mediaGifUrl,
      replyToMsgId: replyToMsgId is int? ? replyToMsgId : this.replyToMsgId,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      isEncrypted: isEncrypted ?? this.isEncrypted,
    );
  }
}

class MessageUpdateTable extends _i1.UpdateTable<MessageTable> {
  MessageUpdateTable(super.table);

  _i1.ColumnValue<int, int> conversationId(int value) => _i1.ColumnValue(
    table.conversationId,
    value,
  );

  _i1.ColumnValue<int, int> senderId(int value) => _i1.ColumnValue(
    table.senderId,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> emojiSequence(
    List<String> value,
  ) => _i1.ColumnValue(
    table.emojiSequence,
    value,
  );

  _i1.ColumnValue<String, String> rawIntent(String? value) => _i1.ColumnValue(
    table.rawIntent,
    value,
  );

  _i1.ColumnValue<String, String> translatedText(String value) =>
      _i1.ColumnValue(
        table.translatedText,
        value,
      );

  _i1.ColumnValue<String, String> tone(String value) => _i1.ColumnValue(
    table.tone,
    value,
  );

  _i1.ColumnValue<String, String> personaUsed(String value) => _i1.ColumnValue(
    table.personaUsed,
    value,
  );

  _i1.ColumnValue<double, double> confidenceScore(double value) =>
      _i1.ColumnValue(
        table.confidenceScore,
        value,
      );

  _i1.ColumnValue<String, String> mediaGifUrl(String? value) => _i1.ColumnValue(
    table.mediaGifUrl,
    value,
  );

  _i1.ColumnValue<int, int> replyToMsgId(int? value) => _i1.ColumnValue(
    table.replyToMsgId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> deliveredAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deliveredAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> readAt(DateTime? value) =>
      _i1.ColumnValue(
        table.readAt,
        value,
      );

  _i1.ColumnValue<bool, bool> isEncrypted(bool value) => _i1.ColumnValue(
    table.isEncrypted,
    value,
  );
}

class MessageTable extends _i1.Table<int?> {
  MessageTable({super.tableRelation}) : super(tableName: 'messages') {
    updateTable = MessageUpdateTable(this);
    conversationId = _i1.ColumnInt(
      'conversationId',
      this,
    );
    senderId = _i1.ColumnInt(
      'senderId',
      this,
    );
    emojiSequence = _i1.ColumnSerializable<List<String>>(
      'emojiSequence',
      this,
    );
    rawIntent = _i1.ColumnString(
      'rawIntent',
      this,
    );
    translatedText = _i1.ColumnString(
      'translatedText',
      this,
    );
    tone = _i1.ColumnString(
      'tone',
      this,
      hasDefault: true,
    );
    personaUsed = _i1.ColumnString(
      'personaUsed',
      this,
    );
    confidenceScore = _i1.ColumnDouble(
      'confidenceScore',
      this,
      hasDefault: true,
    );
    mediaGifUrl = _i1.ColumnString(
      'mediaGifUrl',
      this,
    );
    replyToMsgId = _i1.ColumnInt(
      'replyToMsgId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    deliveredAt = _i1.ColumnDateTime(
      'deliveredAt',
      this,
    );
    readAt = _i1.ColumnDateTime(
      'readAt',
      this,
    );
    isEncrypted = _i1.ColumnBool(
      'isEncrypted',
      this,
      hasDefault: true,
    );
  }

  late final MessageUpdateTable updateTable;

  late final _i1.ColumnInt conversationId;

  _i2.ConversationTable? _conversation;

  late final _i1.ColumnInt senderId;

  _i3.UserTable? _sender;

  late final _i1.ColumnSerializable<List<String>> emojiSequence;

  late final _i1.ColumnString rawIntent;

  late final _i1.ColumnString translatedText;

  late final _i1.ColumnString tone;

  late final _i1.ColumnString personaUsed;

  late final _i1.ColumnDouble confidenceScore;

  late final _i1.ColumnString mediaGifUrl;

  late final _i1.ColumnInt replyToMsgId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime deliveredAt;

  late final _i1.ColumnDateTime readAt;

  late final _i1.ColumnBool isEncrypted;

  _i2.ConversationTable get conversation {
    if (_conversation != null) return _conversation!;
    _conversation = _i1.createRelationTable(
      relationFieldName: 'conversation',
      field: Message.t.conversationId,
      foreignField: _i2.Conversation.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ConversationTable(tableRelation: foreignTableRelation),
    );
    return _conversation!;
  }

  _i3.UserTable get sender {
    if (_sender != null) return _sender!;
    _sender = _i1.createRelationTable(
      relationFieldName: 'sender',
      field: Message.t.senderId,
      foreignField: _i3.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.UserTable(tableRelation: foreignTableRelation),
    );
    return _sender!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    conversationId,
    senderId,
    emojiSequence,
    rawIntent,
    translatedText,
    tone,
    personaUsed,
    confidenceScore,
    mediaGifUrl,
    replyToMsgId,
    createdAt,
    deliveredAt,
    readAt,
    isEncrypted,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'conversation') {
      return conversation;
    }
    if (relationField == 'sender') {
      return sender;
    }
    return null;
  }
}

class MessageInclude extends _i1.IncludeObject {
  MessageInclude._({
    _i2.ConversationInclude? conversation,
    _i3.UserInclude? sender,
  }) {
    _conversation = conversation;
    _sender = sender;
  }

  _i2.ConversationInclude? _conversation;

  _i3.UserInclude? _sender;

  @override
  Map<String, _i1.Include?> get includes => {
    'conversation': _conversation,
    'sender': _sender,
  };

  @override
  _i1.Table<int?> get table => Message.t;
}

class MessageIncludeList extends _i1.IncludeList {
  MessageIncludeList._({
    _i1.WhereExpressionBuilder<MessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Message.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Message.t;
}

class MessageRepository {
  const MessageRepository._();

  final attachRow = const MessageAttachRowRepository._();

  /// Returns a list of [Message]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Message>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MessageTable>? orderByList,
    _i1.Transaction? transaction,
    MessageInclude? include,
  }) async {
    return session.db.find<Message>(
      where: where?.call(Message.t),
      orderBy: orderBy?.call(Message.t),
      orderByList: orderByList?.call(Message.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Message] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Message?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MessageTable>? where,
    int? offset,
    _i1.OrderByBuilder<MessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MessageTable>? orderByList,
    _i1.Transaction? transaction,
    MessageInclude? include,
  }) async {
    return session.db.findFirstRow<Message>(
      where: where?.call(Message.t),
      orderBy: orderBy?.call(Message.t),
      orderByList: orderByList?.call(Message.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Message] by its [id] or null if no such row exists.
  Future<Message?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    MessageInclude? include,
  }) async {
    return session.db.findById<Message>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Message]s in the list and returns the inserted rows.
  ///
  /// The returned [Message]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Message>> insert(
    _i1.Session session,
    List<Message> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Message>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Message] and returns the inserted row.
  ///
  /// The returned [Message] will have its `id` field set.
  Future<Message> insertRow(
    _i1.Session session,
    Message row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Message>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Message]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Message>> update(
    _i1.Session session,
    List<Message> rows, {
    _i1.ColumnSelections<MessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Message>(
      rows,
      columns: columns?.call(Message.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Message]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Message> updateRow(
    _i1.Session session,
    Message row, {
    _i1.ColumnSelections<MessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Message>(
      row,
      columns: columns?.call(Message.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Message] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Message?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<MessageUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Message>(
      id,
      columnValues: columnValues(Message.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Message]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Message>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<MessageUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<MessageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MessageTable>? orderBy,
    _i1.OrderByListBuilder<MessageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Message>(
      columnValues: columnValues(Message.t.updateTable),
      where: where(Message.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Message.t),
      orderByList: orderByList?.call(Message.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Message]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Message>> delete(
    _i1.Session session,
    List<Message> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Message>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Message].
  Future<Message> deleteRow(
    _i1.Session session,
    Message row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Message>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Message>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MessageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Message>(
      where: where(Message.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MessageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Message>(
      where: where?.call(Message.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class MessageAttachRowRepository {
  const MessageAttachRowRepository._();

  /// Creates a relation between the given [Message] and [Conversation]
  /// by setting the [Message]'s foreign key `conversationId` to refer to the [Conversation].
  Future<void> conversation(
    _i1.Session session,
    Message message,
    _i2.Conversation conversation, {
    _i1.Transaction? transaction,
  }) async {
    if (message.id == null) {
      throw ArgumentError.notNull('message.id');
    }
    if (conversation.id == null) {
      throw ArgumentError.notNull('conversation.id');
    }

    var $message = message.copyWith(conversationId: conversation.id);
    await session.db.updateRow<Message>(
      $message,
      columns: [Message.t.conversationId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Message] and [User]
  /// by setting the [Message]'s foreign key `senderId` to refer to the [User].
  Future<void> sender(
    _i1.Session session,
    Message message,
    _i3.User sender, {
    _i1.Transaction? transaction,
  }) async {
    if (message.id == null) {
      throw ArgumentError.notNull('message.id');
    }
    if (sender.id == null) {
      throw ArgumentError.notNull('sender.id');
    }

    var $message = message.copyWith(senderId: sender.id);
    await session.db.updateRow<Message>(
      $message,
      columns: [Message.t.senderId],
      transaction: transaction,
    );
  }
}
