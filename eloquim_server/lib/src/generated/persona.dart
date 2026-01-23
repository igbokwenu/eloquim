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
import 'user.dart' as _i2;
import 'package:eloquim_server/src/generated/protocol.dart' as _i3;

abstract class Persona
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Persona._({
    this.id,
    required this.name,
    required this.creatorId,
    this.creator,
    bool? isOfficial,
    required this.description,
    required this.traitsJson,
    required this.communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  }) : isOfficial = isOfficial ?? false,
       packVersion = packVersion ?? '1.0',
       createdAt = createdAt ?? DateTime.now();

  factory Persona({
    int? id,
    required String name,
    required int creatorId,
    _i2.User? creator,
    bool? isOfficial,
    required String description,
    required String traitsJson,
    required String communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  }) = _PersonaImpl;

  factory Persona.fromJson(Map<String, dynamic> jsonSerialization) {
    return Persona(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      creatorId: jsonSerialization['creatorId'] as int,
      creator: jsonSerialization['creator'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['creator']),
      isOfficial: jsonSerialization['isOfficial'] as bool?,
      description: jsonSerialization['description'] as String,
      traitsJson: jsonSerialization['traitsJson'] as String,
      communicationStyle: jsonSerialization['communicationStyle'] as String,
      packVersion: jsonSerialization['packVersion'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = PersonaTable();

  static const db = PersonaRepository._();

  @override
  int? id;

  String name;

  int creatorId;

  _i2.User? creator;

  bool isOfficial;

  String description;

  String traitsJson;

  String communicationStyle;

  String packVersion;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Persona]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Persona copyWith({
    int? id,
    String? name,
    int? creatorId,
    _i2.User? creator,
    bool? isOfficial,
    String? description,
    String? traitsJson,
    String? communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Persona',
      if (id != null) 'id': id,
      'name': name,
      'creatorId': creatorId,
      if (creator != null) 'creator': creator?.toJson(),
      'isOfficial': isOfficial,
      'description': description,
      'traitsJson': traitsJson,
      'communicationStyle': communicationStyle,
      'packVersion': packVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Persona',
      if (id != null) 'id': id,
      'name': name,
      'creatorId': creatorId,
      if (creator != null) 'creator': creator?.toJsonForProtocol(),
      'isOfficial': isOfficial,
      'description': description,
      'traitsJson': traitsJson,
      'communicationStyle': communicationStyle,
      'packVersion': packVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  static PersonaInclude include({_i2.UserInclude? creator}) {
    return PersonaInclude._(creator: creator);
  }

  static PersonaIncludeList includeList({
    _i1.WhereExpressionBuilder<PersonaTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PersonaTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonaTable>? orderByList,
    PersonaInclude? include,
  }) {
    return PersonaIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Persona.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Persona.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PersonaImpl extends Persona {
  _PersonaImpl({
    int? id,
    required String name,
    required int creatorId,
    _i2.User? creator,
    bool? isOfficial,
    required String description,
    required String traitsJson,
    required String communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         creatorId: creatorId,
         creator: creator,
         isOfficial: isOfficial,
         description: description,
         traitsJson: traitsJson,
         communicationStyle: communicationStyle,
         packVersion: packVersion,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Persona]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Persona copyWith({
    Object? id = _Undefined,
    String? name,
    int? creatorId,
    Object? creator = _Undefined,
    bool? isOfficial,
    String? description,
    String? traitsJson,
    String? communicationStyle,
    String? packVersion,
    DateTime? createdAt,
  }) {
    return Persona(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      creatorId: creatorId ?? this.creatorId,
      creator: creator is _i2.User? ? creator : this.creator?.copyWith(),
      isOfficial: isOfficial ?? this.isOfficial,
      description: description ?? this.description,
      traitsJson: traitsJson ?? this.traitsJson,
      communicationStyle: communicationStyle ?? this.communicationStyle,
      packVersion: packVersion ?? this.packVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PersonaUpdateTable extends _i1.UpdateTable<PersonaTable> {
  PersonaUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> creatorId(int value) => _i1.ColumnValue(
    table.creatorId,
    value,
  );

  _i1.ColumnValue<bool, bool> isOfficial(bool value) => _i1.ColumnValue(
    table.isOfficial,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> traitsJson(String value) => _i1.ColumnValue(
    table.traitsJson,
    value,
  );

  _i1.ColumnValue<String, String> communicationStyle(String value) =>
      _i1.ColumnValue(
        table.communicationStyle,
        value,
      );

  _i1.ColumnValue<String, String> packVersion(String value) => _i1.ColumnValue(
    table.packVersion,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class PersonaTable extends _i1.Table<int?> {
  PersonaTable({super.tableRelation}) : super(tableName: 'personas') {
    updateTable = PersonaUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    creatorId = _i1.ColumnInt(
      'creatorId',
      this,
    );
    isOfficial = _i1.ColumnBool(
      'isOfficial',
      this,
      hasDefault: true,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    traitsJson = _i1.ColumnString(
      'traitsJson',
      this,
    );
    communicationStyle = _i1.ColumnString(
      'communicationStyle',
      this,
    );
    packVersion = _i1.ColumnString(
      'packVersion',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final PersonaUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt creatorId;

  _i2.UserTable? _creator;

  late final _i1.ColumnBool isOfficial;

  late final _i1.ColumnString description;

  late final _i1.ColumnString traitsJson;

  late final _i1.ColumnString communicationStyle;

  late final _i1.ColumnString packVersion;

  late final _i1.ColumnDateTime createdAt;

  _i2.UserTable get creator {
    if (_creator != null) return _creator!;
    _creator = _i1.createRelationTable(
      relationFieldName: 'creator',
      field: Persona.t.creatorId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _creator!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    creatorId,
    isOfficial,
    description,
    traitsJson,
    communicationStyle,
    packVersion,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'creator') {
      return creator;
    }
    return null;
  }
}

class PersonaInclude extends _i1.IncludeObject {
  PersonaInclude._({_i2.UserInclude? creator}) {
    _creator = creator;
  }

  _i2.UserInclude? _creator;

  @override
  Map<String, _i1.Include?> get includes => {'creator': _creator};

  @override
  _i1.Table<int?> get table => Persona.t;
}

class PersonaIncludeList extends _i1.IncludeList {
  PersonaIncludeList._({
    _i1.WhereExpressionBuilder<PersonaTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Persona.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Persona.t;
}

class PersonaRepository {
  const PersonaRepository._();

  final attachRow = const PersonaAttachRowRepository._();

  /// Returns a list of [Persona]s matching the given query parameters.
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
  Future<List<Persona>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonaTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PersonaTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonaTable>? orderByList,
    _i1.Transaction? transaction,
    PersonaInclude? include,
  }) async {
    return session.db.find<Persona>(
      where: where?.call(Persona.t),
      orderBy: orderBy?.call(Persona.t),
      orderByList: orderByList?.call(Persona.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Persona] matching the given query parameters.
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
  Future<Persona?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonaTable>? where,
    int? offset,
    _i1.OrderByBuilder<PersonaTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonaTable>? orderByList,
    _i1.Transaction? transaction,
    PersonaInclude? include,
  }) async {
    return session.db.findFirstRow<Persona>(
      where: where?.call(Persona.t),
      orderBy: orderBy?.call(Persona.t),
      orderByList: orderByList?.call(Persona.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Persona] by its [id] or null if no such row exists.
  Future<Persona?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PersonaInclude? include,
  }) async {
    return session.db.findById<Persona>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Persona]s in the list and returns the inserted rows.
  ///
  /// The returned [Persona]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Persona>> insert(
    _i1.Session session,
    List<Persona> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Persona>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Persona] and returns the inserted row.
  ///
  /// The returned [Persona] will have its `id` field set.
  Future<Persona> insertRow(
    _i1.Session session,
    Persona row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Persona>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Persona]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Persona>> update(
    _i1.Session session,
    List<Persona> rows, {
    _i1.ColumnSelections<PersonaTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Persona>(
      rows,
      columns: columns?.call(Persona.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Persona]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Persona> updateRow(
    _i1.Session session,
    Persona row, {
    _i1.ColumnSelections<PersonaTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Persona>(
      row,
      columns: columns?.call(Persona.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Persona] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Persona?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PersonaUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Persona>(
      id,
      columnValues: columnValues(Persona.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Persona]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Persona>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PersonaUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PersonaTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PersonaTable>? orderBy,
    _i1.OrderByListBuilder<PersonaTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Persona>(
      columnValues: columnValues(Persona.t.updateTable),
      where: where(Persona.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Persona.t),
      orderByList: orderByList?.call(Persona.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Persona]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Persona>> delete(
    _i1.Session session,
    List<Persona> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Persona>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Persona].
  Future<Persona> deleteRow(
    _i1.Session session,
    Persona row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Persona>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Persona>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PersonaTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Persona>(
      where: where(Persona.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonaTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Persona>(
      where: where?.call(Persona.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PersonaAttachRowRepository {
  const PersonaAttachRowRepository._();

  /// Creates a relation between the given [Persona] and [User]
  /// by setting the [Persona]'s foreign key `creatorId` to refer to the [User].
  Future<void> creator(
    _i1.Session session,
    Persona persona,
    _i2.User creator, {
    _i1.Transaction? transaction,
  }) async {
    if (persona.id == null) {
      throw ArgumentError.notNull('persona.id');
    }
    if (creator.id == null) {
      throw ArgumentError.notNull('creator.id');
    }

    var $persona = persona.copyWith(creatorId: creator.id);
    await session.db.updateRow<Persona>(
      $persona,
      columns: [Persona.t.creatorId],
      transaction: transaction,
    );
  }
}
