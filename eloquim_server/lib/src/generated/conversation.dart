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

abstract class Conversation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Conversation._({
    this.id,
    String? type,
    this.title,
    required this.participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    this.chemistryScore,
    String? status,
  }) : type = type ?? 'p2p',
       startedAt = startedAt ?? DateTime.now(),
       lastMessageAt = lastMessageAt ?? DateTime.now(),
       status = status ?? 'active';

  factory Conversation({
    int? id,
    String? type,
    String? title,
    required List<int> participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    double? chemistryScore,
    String? status,
  }) = _ConversationImpl;

  factory Conversation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Conversation(
      id: jsonSerialization['id'] as int?,
      type: jsonSerialization['type'] as String?,
      title: jsonSerialization['title'] as String?,
      participantIds: _i2.Protocol().deserialize<List<int>>(
        jsonSerialization['participantIds'],
      ),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      lastMessageAt: jsonSerialization['lastMessageAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageAt'],
            ),
      chemistryScore: (jsonSerialization['chemistryScore'] as num?)?.toDouble(),
      status: jsonSerialization['status'] as String?,
    );
  }

  static final t = ConversationTable();

  static const db = ConversationRepository._();

  @override
  int? id;

  String type;

  String? title;

  List<int> participantIds;

  DateTime startedAt;

  DateTime lastMessageAt;

  double? chemistryScore;

  String status;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Conversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Conversation copyWith({
    int? id,
    String? type,
    String? title,
    List<int>? participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    double? chemistryScore,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Conversation',
      if (id != null) 'id': id,
      'type': type,
      if (title != null) 'title': title,
      'participantIds': participantIds.toJson(),
      'startedAt': startedAt.toJson(),
      'lastMessageAt': lastMessageAt.toJson(),
      if (chemistryScore != null) 'chemistryScore': chemistryScore,
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Conversation',
      if (id != null) 'id': id,
      'type': type,
      if (title != null) 'title': title,
      'participantIds': participantIds.toJson(),
      'startedAt': startedAt.toJson(),
      'lastMessageAt': lastMessageAt.toJson(),
      if (chemistryScore != null) 'chemistryScore': chemistryScore,
      'status': status,
    };
  }

  static ConversationInclude include() {
    return ConversationInclude._();
  }

  static ConversationIncludeList includeList({
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConversationTable>? orderByList,
    ConversationInclude? include,
  }) {
    return ConversationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Conversation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Conversation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConversationImpl extends Conversation {
  _ConversationImpl({
    int? id,
    String? type,
    String? title,
    required List<int> participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    double? chemistryScore,
    String? status,
  }) : super._(
         id: id,
         type: type,
         title: title,
         participantIds: participantIds,
         startedAt: startedAt,
         lastMessageAt: lastMessageAt,
         chemistryScore: chemistryScore,
         status: status,
       );

  /// Returns a shallow copy of this [Conversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Conversation copyWith({
    Object? id = _Undefined,
    String? type,
    Object? title = _Undefined,
    List<int>? participantIds,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    Object? chemistryScore = _Undefined,
    String? status,
  }) {
    return Conversation(
      id: id is int? ? id : this.id,
      type: type ?? this.type,
      title: title is String? ? title : this.title,
      participantIds:
          participantIds ?? this.participantIds.map((e0) => e0).toList(),
      startedAt: startedAt ?? this.startedAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      chemistryScore: chemistryScore is double?
          ? chemistryScore
          : this.chemistryScore,
      status: status ?? this.status,
    );
  }
}

class ConversationUpdateTable extends _i1.UpdateTable<ConversationTable> {
  ConversationUpdateTable(super.table);

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> title(String? value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<List<int>, List<int>> participantIds(List<int> value) =>
      _i1.ColumnValue(
        table.participantIds,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _i1.ColumnValue(
        table.startedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastMessageAt(DateTime value) =>
      _i1.ColumnValue(
        table.lastMessageAt,
        value,
      );

  _i1.ColumnValue<double, double> chemistryScore(double? value) =>
      _i1.ColumnValue(
        table.chemistryScore,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );
}

class ConversationTable extends _i1.Table<int?> {
  ConversationTable({super.tableRelation}) : super(tableName: 'conversations') {
    updateTable = ConversationUpdateTable(this);
    type = _i1.ColumnString(
      'type',
      this,
      hasDefault: true,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    participantIds = _i1.ColumnSerializable<List<int>>(
      'participantIds',
      this,
    );
    startedAt = _i1.ColumnDateTime(
      'startedAt',
      this,
      hasDefault: true,
    );
    lastMessageAt = _i1.ColumnDateTime(
      'lastMessageAt',
      this,
      hasDefault: true,
    );
    chemistryScore = _i1.ColumnDouble(
      'chemistryScore',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
  }

  late final ConversationUpdateTable updateTable;

  late final _i1.ColumnString type;

  late final _i1.ColumnString title;

  late final _i1.ColumnSerializable<List<int>> participantIds;

  late final _i1.ColumnDateTime startedAt;

  late final _i1.ColumnDateTime lastMessageAt;

  late final _i1.ColumnDouble chemistryScore;

  late final _i1.ColumnString status;

  @override
  List<_i1.Column> get columns => [
    id,
    type,
    title,
    participantIds,
    startedAt,
    lastMessageAt,
    chemistryScore,
    status,
  ];
}

class ConversationInclude extends _i1.IncludeObject {
  ConversationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Conversation.t;
}

class ConversationIncludeList extends _i1.IncludeList {
  ConversationIncludeList._({
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Conversation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Conversation.t;
}

class ConversationRepository {
  const ConversationRepository._();

  /// Returns a list of [Conversation]s matching the given query parameters.
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
  Future<List<Conversation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConversationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Conversation>(
      where: where?.call(Conversation.t),
      orderBy: orderBy?.call(Conversation.t),
      orderByList: orderByList?.call(Conversation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Conversation] matching the given query parameters.
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
  Future<Conversation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConversationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Conversation>(
      where: where?.call(Conversation.t),
      orderBy: orderBy?.call(Conversation.t),
      orderByList: orderByList?.call(Conversation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Conversation] by its [id] or null if no such row exists.
  Future<Conversation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Conversation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Conversation]s in the list and returns the inserted rows.
  ///
  /// The returned [Conversation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Conversation>> insert(
    _i1.Session session,
    List<Conversation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Conversation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Conversation] and returns the inserted row.
  ///
  /// The returned [Conversation] will have its `id` field set.
  Future<Conversation> insertRow(
    _i1.Session session,
    Conversation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Conversation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Conversation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Conversation>> update(
    _i1.Session session,
    List<Conversation> rows, {
    _i1.ColumnSelections<ConversationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Conversation>(
      rows,
      columns: columns?.call(Conversation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Conversation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Conversation> updateRow(
    _i1.Session session,
    Conversation row, {
    _i1.ColumnSelections<ConversationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Conversation>(
      row,
      columns: columns?.call(Conversation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Conversation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Conversation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ConversationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Conversation>(
      id,
      columnValues: columnValues(Conversation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Conversation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Conversation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ConversationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ConversationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConversationTable>? orderBy,
    _i1.OrderByListBuilder<ConversationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Conversation>(
      columnValues: columnValues(Conversation.t.updateTable),
      where: where(Conversation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Conversation.t),
      orderByList: orderByList?.call(Conversation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Conversation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Conversation>> delete(
    _i1.Session session,
    List<Conversation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Conversation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Conversation].
  Future<Conversation> deleteRow(
    _i1.Session session,
    Conversation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Conversation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Conversation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ConversationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Conversation>(
      where: where(Conversation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Conversation>(
      where: where?.call(Conversation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
