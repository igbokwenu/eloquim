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

abstract class TokenLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = TokenLogTable();

  static const db = TokenLogRepository._();

  @override
  int? id;

  int userId;

  int tokenCount;

  double estimatedCost;

  String apiCallType;

  DateTime timestamp;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static TokenLogInclude include() {
    return TokenLogInclude._();
  }

  static TokenLogIncludeList includeList({
    _i1.WhereExpressionBuilder<TokenLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TokenLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TokenLogTable>? orderByList,
    TokenLogInclude? include,
  }) {
    return TokenLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TokenLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TokenLog.t),
      include: include,
    );
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

class TokenLogUpdateTable extends _i1.UpdateTable<TokenLogTable> {
  TokenLogUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> tokenCount(int value) => _i1.ColumnValue(
    table.tokenCount,
    value,
  );

  _i1.ColumnValue<double, double> estimatedCost(double value) =>
      _i1.ColumnValue(
        table.estimatedCost,
        value,
      );

  _i1.ColumnValue<String, String> apiCallType(String value) => _i1.ColumnValue(
    table.apiCallType,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );
}

class TokenLogTable extends _i1.Table<int?> {
  TokenLogTable({super.tableRelation}) : super(tableName: 'token_logs') {
    updateTable = TokenLogUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    tokenCount = _i1.ColumnInt(
      'tokenCount',
      this,
    );
    estimatedCost = _i1.ColumnDouble(
      'estimatedCost',
      this,
    );
    apiCallType = _i1.ColumnString(
      'apiCallType',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
      hasDefault: true,
    );
  }

  late final TokenLogUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt tokenCount;

  late final _i1.ColumnDouble estimatedCost;

  late final _i1.ColumnString apiCallType;

  late final _i1.ColumnDateTime timestamp;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    tokenCount,
    estimatedCost,
    apiCallType,
    timestamp,
  ];
}

class TokenLogInclude extends _i1.IncludeObject {
  TokenLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TokenLog.t;
}

class TokenLogIncludeList extends _i1.IncludeList {
  TokenLogIncludeList._({
    _i1.WhereExpressionBuilder<TokenLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TokenLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TokenLog.t;
}

class TokenLogRepository {
  const TokenLogRepository._();

  /// Returns a list of [TokenLog]s matching the given query parameters.
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
  Future<List<TokenLog>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TokenLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TokenLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TokenLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TokenLog>(
      where: where?.call(TokenLog.t),
      orderBy: orderBy?.call(TokenLog.t),
      orderByList: orderByList?.call(TokenLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TokenLog] matching the given query parameters.
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
  Future<TokenLog?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TokenLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<TokenLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TokenLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TokenLog>(
      where: where?.call(TokenLog.t),
      orderBy: orderBy?.call(TokenLog.t),
      orderByList: orderByList?.call(TokenLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TokenLog] by its [id] or null if no such row exists.
  Future<TokenLog?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TokenLog>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TokenLog]s in the list and returns the inserted rows.
  ///
  /// The returned [TokenLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TokenLog>> insert(
    _i1.Session session,
    List<TokenLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TokenLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TokenLog] and returns the inserted row.
  ///
  /// The returned [TokenLog] will have its `id` field set.
  Future<TokenLog> insertRow(
    _i1.Session session,
    TokenLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TokenLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TokenLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TokenLog>> update(
    _i1.Session session,
    List<TokenLog> rows, {
    _i1.ColumnSelections<TokenLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TokenLog>(
      rows,
      columns: columns?.call(TokenLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TokenLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TokenLog> updateRow(
    _i1.Session session,
    TokenLog row, {
    _i1.ColumnSelections<TokenLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TokenLog>(
      row,
      columns: columns?.call(TokenLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TokenLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TokenLog?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TokenLogUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TokenLog>(
      id,
      columnValues: columnValues(TokenLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TokenLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TokenLog>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TokenLogUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TokenLogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TokenLogTable>? orderBy,
    _i1.OrderByListBuilder<TokenLogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TokenLog>(
      columnValues: columnValues(TokenLog.t.updateTable),
      where: where(TokenLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TokenLog.t),
      orderByList: orderByList?.call(TokenLog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TokenLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TokenLog>> delete(
    _i1.Session session,
    List<TokenLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TokenLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TokenLog].
  Future<TokenLog> deleteRow(
    _i1.Session session,
    TokenLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TokenLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TokenLog>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TokenLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TokenLog>(
      where: where(TokenLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TokenLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TokenLog>(
      where: where?.call(TokenLog.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
