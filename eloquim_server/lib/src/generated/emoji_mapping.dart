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
import 'persona.dart' as _i2;
import 'package:eloquim_server/src/generated/protocol.dart' as _i3;

abstract class EmojiMapping
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  EmojiMapping._({
    this.id,
    required this.personaId,
    this.persona,
    required this.emojiSequence,
    required this.canonicalText,
    required this.contextTags,
    int? usageCount,
    DateTime? createdAt,
  }) : usageCount = usageCount ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory EmojiMapping({
    int? id,
    required int personaId,
    _i2.Persona? persona,
    required String emojiSequence,
    required String canonicalText,
    required List<String> contextTags,
    int? usageCount,
    DateTime? createdAt,
  }) = _EmojiMappingImpl;

  factory EmojiMapping.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmojiMapping(
      id: jsonSerialization['id'] as int?,
      personaId: jsonSerialization['personaId'] as int,
      persona: jsonSerialization['persona'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Persona>(
              jsonSerialization['persona'],
            ),
      emojiSequence: jsonSerialization['emojiSequence'] as String,
      canonicalText: jsonSerialization['canonicalText'] as String,
      contextTags: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['contextTags'],
      ),
      usageCount: jsonSerialization['usageCount'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = EmojiMappingTable();

  static const db = EmojiMappingRepository._();

  @override
  int? id;

  int personaId;

  _i2.Persona? persona;

  String emojiSequence;

  String canonicalText;

  List<String> contextTags;

  int usageCount;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmojiMapping]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmojiMapping copyWith({
    int? id,
    int? personaId,
    _i2.Persona? persona,
    String? emojiSequence,
    String? canonicalText,
    List<String>? contextTags,
    int? usageCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmojiMapping',
      if (id != null) 'id': id,
      'personaId': personaId,
      if (persona != null) 'persona': persona?.toJson(),
      'emojiSequence': emojiSequence,
      'canonicalText': canonicalText,
      'contextTags': contextTags.toJson(),
      'usageCount': usageCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EmojiMapping',
      if (id != null) 'id': id,
      'personaId': personaId,
      if (persona != null) 'persona': persona?.toJsonForProtocol(),
      'emojiSequence': emojiSequence,
      'canonicalText': canonicalText,
      'contextTags': contextTags.toJson(),
      'usageCount': usageCount,
      'createdAt': createdAt.toJson(),
    };
  }

  static EmojiMappingInclude include({_i2.PersonaInclude? persona}) {
    return EmojiMappingInclude._(persona: persona);
  }

  static EmojiMappingIncludeList includeList({
    _i1.WhereExpressionBuilder<EmojiMappingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmojiMappingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmojiMappingTable>? orderByList,
    EmojiMappingInclude? include,
  }) {
    return EmojiMappingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmojiMapping.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmojiMapping.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmojiMappingImpl extends EmojiMapping {
  _EmojiMappingImpl({
    int? id,
    required int personaId,
    _i2.Persona? persona,
    required String emojiSequence,
    required String canonicalText,
    required List<String> contextTags,
    int? usageCount,
    DateTime? createdAt,
  }) : super._(
         id: id,
         personaId: personaId,
         persona: persona,
         emojiSequence: emojiSequence,
         canonicalText: canonicalText,
         contextTags: contextTags,
         usageCount: usageCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EmojiMapping]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmojiMapping copyWith({
    Object? id = _Undefined,
    int? personaId,
    Object? persona = _Undefined,
    String? emojiSequence,
    String? canonicalText,
    List<String>? contextTags,
    int? usageCount,
    DateTime? createdAt,
  }) {
    return EmojiMapping(
      id: id is int? ? id : this.id,
      personaId: personaId ?? this.personaId,
      persona: persona is _i2.Persona? ? persona : this.persona?.copyWith(),
      emojiSequence: emojiSequence ?? this.emojiSequence,
      canonicalText: canonicalText ?? this.canonicalText,
      contextTags: contextTags ?? this.contextTags.map((e0) => e0).toList(),
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class EmojiMappingUpdateTable extends _i1.UpdateTable<EmojiMappingTable> {
  EmojiMappingUpdateTable(super.table);

  _i1.ColumnValue<int, int> personaId(int value) => _i1.ColumnValue(
    table.personaId,
    value,
  );

  _i1.ColumnValue<String, String> emojiSequence(String value) =>
      _i1.ColumnValue(
        table.emojiSequence,
        value,
      );

  _i1.ColumnValue<String, String> canonicalText(String value) =>
      _i1.ColumnValue(
        table.canonicalText,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> contextTags(List<String> value) =>
      _i1.ColumnValue(
        table.contextTags,
        value,
      );

  _i1.ColumnValue<int, int> usageCount(int value) => _i1.ColumnValue(
    table.usageCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class EmojiMappingTable extends _i1.Table<int?> {
  EmojiMappingTable({super.tableRelation})
    : super(tableName: 'emoji_mappings') {
    updateTable = EmojiMappingUpdateTable(this);
    personaId = _i1.ColumnInt(
      'personaId',
      this,
    );
    emojiSequence = _i1.ColumnString(
      'emojiSequence',
      this,
    );
    canonicalText = _i1.ColumnString(
      'canonicalText',
      this,
    );
    contextTags = _i1.ColumnSerializable<List<String>>(
      'contextTags',
      this,
    );
    usageCount = _i1.ColumnInt(
      'usageCount',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final EmojiMappingUpdateTable updateTable;

  late final _i1.ColumnInt personaId;

  _i2.PersonaTable? _persona;

  late final _i1.ColumnString emojiSequence;

  late final _i1.ColumnString canonicalText;

  late final _i1.ColumnSerializable<List<String>> contextTags;

  late final _i1.ColumnInt usageCount;

  late final _i1.ColumnDateTime createdAt;

  _i2.PersonaTable get persona {
    if (_persona != null) return _persona!;
    _persona = _i1.createRelationTable(
      relationFieldName: 'persona',
      field: EmojiMapping.t.personaId,
      foreignField: _i2.Persona.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonaTable(tableRelation: foreignTableRelation),
    );
    return _persona!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    personaId,
    emojiSequence,
    canonicalText,
    contextTags,
    usageCount,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'persona') {
      return persona;
    }
    return null;
  }
}

class EmojiMappingInclude extends _i1.IncludeObject {
  EmojiMappingInclude._({_i2.PersonaInclude? persona}) {
    _persona = persona;
  }

  _i2.PersonaInclude? _persona;

  @override
  Map<String, _i1.Include?> get includes => {'persona': _persona};

  @override
  _i1.Table<int?> get table => EmojiMapping.t;
}

class EmojiMappingIncludeList extends _i1.IncludeList {
  EmojiMappingIncludeList._({
    _i1.WhereExpressionBuilder<EmojiMappingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmojiMapping.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => EmojiMapping.t;
}

class EmojiMappingRepository {
  const EmojiMappingRepository._();

  final attachRow = const EmojiMappingAttachRowRepository._();

  /// Returns a list of [EmojiMapping]s matching the given query parameters.
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
  Future<List<EmojiMapping>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmojiMappingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmojiMappingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmojiMappingTable>? orderByList,
    _i1.Transaction? transaction,
    EmojiMappingInclude? include,
  }) async {
    return session.db.find<EmojiMapping>(
      where: where?.call(EmojiMapping.t),
      orderBy: orderBy?.call(EmojiMapping.t),
      orderByList: orderByList?.call(EmojiMapping.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [EmojiMapping] matching the given query parameters.
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
  Future<EmojiMapping?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmojiMappingTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmojiMappingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmojiMappingTable>? orderByList,
    _i1.Transaction? transaction,
    EmojiMappingInclude? include,
  }) async {
    return session.db.findFirstRow<EmojiMapping>(
      where: where?.call(EmojiMapping.t),
      orderBy: orderBy?.call(EmojiMapping.t),
      orderByList: orderByList?.call(EmojiMapping.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [EmojiMapping] by its [id] or null if no such row exists.
  Future<EmojiMapping?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    EmojiMappingInclude? include,
  }) async {
    return session.db.findById<EmojiMapping>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [EmojiMapping]s in the list and returns the inserted rows.
  ///
  /// The returned [EmojiMapping]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmojiMapping>> insert(
    _i1.Session session,
    List<EmojiMapping> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmojiMapping>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmojiMapping] and returns the inserted row.
  ///
  /// The returned [EmojiMapping] will have its `id` field set.
  Future<EmojiMapping> insertRow(
    _i1.Session session,
    EmojiMapping row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmojiMapping>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmojiMapping]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmojiMapping>> update(
    _i1.Session session,
    List<EmojiMapping> rows, {
    _i1.ColumnSelections<EmojiMappingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmojiMapping>(
      rows,
      columns: columns?.call(EmojiMapping.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmojiMapping]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmojiMapping> updateRow(
    _i1.Session session,
    EmojiMapping row, {
    _i1.ColumnSelections<EmojiMappingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmojiMapping>(
      row,
      columns: columns?.call(EmojiMapping.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmojiMapping] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmojiMapping?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<EmojiMappingUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EmojiMapping>(
      id,
      columnValues: columnValues(EmojiMapping.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmojiMapping]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EmojiMapping>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<EmojiMappingUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EmojiMappingTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmojiMappingTable>? orderBy,
    _i1.OrderByListBuilder<EmojiMappingTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EmojiMapping>(
      columnValues: columnValues(EmojiMapping.t.updateTable),
      where: where(EmojiMapping.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmojiMapping.t),
      orderByList: orderByList?.call(EmojiMapping.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EmojiMapping]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmojiMapping>> delete(
    _i1.Session session,
    List<EmojiMapping> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmojiMapping>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmojiMapping].
  Future<EmojiMapping> deleteRow(
    _i1.Session session,
    EmojiMapping row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmojiMapping>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmojiMapping>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmojiMappingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmojiMapping>(
      where: where(EmojiMapping.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmojiMappingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmojiMapping>(
      where: where?.call(EmojiMapping.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class EmojiMappingAttachRowRepository {
  const EmojiMappingAttachRowRepository._();

  /// Creates a relation between the given [EmojiMapping] and [Persona]
  /// by setting the [EmojiMapping]'s foreign key `personaId` to refer to the [Persona].
  Future<void> persona(
    _i1.Session session,
    EmojiMapping emojiMapping,
    _i2.Persona persona, {
    _i1.Transaction? transaction,
  }) async {
    if (emojiMapping.id == null) {
      throw ArgumentError.notNull('emojiMapping.id');
    }
    if (persona.id == null) {
      throw ArgumentError.notNull('persona.id');
    }

    var $emojiMapping = emojiMapping.copyWith(personaId: persona.id);
    await session.db.updateRow<EmojiMapping>(
      $emojiMapping,
      columns: [EmojiMapping.t.personaId],
      transaction: transaction,
    );
  }
}
