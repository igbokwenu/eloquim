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

abstract class User implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  User._({
    this.id,
    required this.username,
    this.email,
    this.gender,
    this.age,
    this.country,
    required this.personaId,
    this.persona,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  }) : emojiSignature = emojiSignature ?? '✨🎵💫',
       hasDoneTutorial = hasDoneTutorial ?? false,
       createdAt = createdAt ?? DateTime.now(),
       lastSeen = lastSeen ?? DateTime.now(),
       isAnonymous = isAnonymous ?? true;

  factory User({
    int? id,
    required String username,
    String? email,
    String? gender,
    int? age,
    String? country,
    required int personaId,
    _i2.Persona? persona,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] as int?,
      username: jsonSerialization['username'] as String,
      email: jsonSerialization['email'] as String?,
      gender: jsonSerialization['gender'] as String?,
      age: jsonSerialization['age'] as int?,
      country: jsonSerialization['country'] as String?,
      personaId: jsonSerialization['personaId'] as int,
      persona: jsonSerialization['persona'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Persona>(
              jsonSerialization['persona'],
            ),
      emojiSignature: jsonSerialization['emojiSignature'] as String?,
      hasDoneTutorial: jsonSerialization['hasDoneTutorial'] as bool?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastSeen: jsonSerialization['lastSeen'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeen']),
      isAnonymous: jsonSerialization['isAnonymous'] as bool?,
    );
  }

  static final t = UserTable();

  static const db = UserRepository._();

  @override
  int? id;

  String username;

  String? email;

  String? gender;

  int? age;

  String? country;

  int personaId;

  _i2.Persona? persona;

  String emojiSignature;

  bool hasDoneTutorial;

  DateTime createdAt;

  DateTime lastSeen;

  bool isAnonymous;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? gender,
    int? age,
    String? country,
    int? personaId,
    _i2.Persona? persona,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id,
      'username': username,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (country != null) 'country': country,
      'personaId': personaId,
      if (persona != null) 'persona': persona?.toJson(),
      'emojiSignature': emojiSignature,
      'hasDoneTutorial': hasDoneTutorial,
      'createdAt': createdAt.toJson(),
      'lastSeen': lastSeen.toJson(),
      'isAnonymous': isAnonymous,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id,
      'username': username,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (country != null) 'country': country,
      'personaId': personaId,
      if (persona != null) 'persona': persona?.toJsonForProtocol(),
      'emojiSignature': emojiSignature,
      'hasDoneTutorial': hasDoneTutorial,
      'createdAt': createdAt.toJson(),
      'lastSeen': lastSeen.toJson(),
      'isAnonymous': isAnonymous,
    };
  }

  static UserInclude include({_i2.PersonaInclude? persona}) {
    return UserInclude._(persona: persona);
  }

  static UserIncludeList includeList({
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    UserInclude? include,
  }) {
    return UserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(User.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(User.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserImpl extends User {
  _UserImpl({
    int? id,
    required String username,
    String? email,
    String? gender,
    int? age,
    String? country,
    required int personaId,
    _i2.Persona? persona,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  }) : super._(
         id: id,
         username: username,
         email: email,
         gender: gender,
         age: age,
         country: country,
         personaId: personaId,
         persona: persona,
         emojiSignature: emojiSignature,
         hasDoneTutorial: hasDoneTutorial,
         createdAt: createdAt,
         lastSeen: lastSeen,
         isAnonymous: isAnonymous,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    String? username,
    Object? email = _Undefined,
    Object? gender = _Undefined,
    Object? age = _Undefined,
    Object? country = _Undefined,
    int? personaId,
    Object? persona = _Undefined,
    String? emojiSignature,
    bool? hasDoneTutorial,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isAnonymous,
  }) {
    return User(
      id: id is int? ? id : this.id,
      username: username ?? this.username,
      email: email is String? ? email : this.email,
      gender: gender is String? ? gender : this.gender,
      age: age is int? ? age : this.age,
      country: country is String? ? country : this.country,
      personaId: personaId ?? this.personaId,
      persona: persona is _i2.Persona? ? persona : this.persona?.copyWith(),
      emojiSignature: emojiSignature ?? this.emojiSignature,
      hasDoneTutorial: hasDoneTutorial ?? this.hasDoneTutorial,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}

class UserUpdateTable extends _i1.UpdateTable<UserTable> {
  UserUpdateTable(super.table);

  _i1.ColumnValue<String, String> username(String value) => _i1.ColumnValue(
    table.username,
    value,
  );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> gender(String? value) => _i1.ColumnValue(
    table.gender,
    value,
  );

  _i1.ColumnValue<int, int> age(int? value) => _i1.ColumnValue(
    table.age,
    value,
  );

  _i1.ColumnValue<String, String> country(String? value) => _i1.ColumnValue(
    table.country,
    value,
  );

  _i1.ColumnValue<int, int> personaId(int value) => _i1.ColumnValue(
    table.personaId,
    value,
  );

  _i1.ColumnValue<String, String> emojiSignature(String value) =>
      _i1.ColumnValue(
        table.emojiSignature,
        value,
      );

  _i1.ColumnValue<bool, bool> hasDoneTutorial(bool value) => _i1.ColumnValue(
    table.hasDoneTutorial,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastSeen(DateTime value) =>
      _i1.ColumnValue(
        table.lastSeen,
        value,
      );

  _i1.ColumnValue<bool, bool> isAnonymous(bool value) => _i1.ColumnValue(
    table.isAnonymous,
    value,
  );
}

class UserTable extends _i1.Table<int?> {
  UserTable({super.tableRelation}) : super(tableName: 'users') {
    updateTable = UserUpdateTable(this);
    username = _i1.ColumnString(
      'username',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    gender = _i1.ColumnString(
      'gender',
      this,
    );
    age = _i1.ColumnInt(
      'age',
      this,
    );
    country = _i1.ColumnString(
      'country',
      this,
    );
    personaId = _i1.ColumnInt(
      'personaId',
      this,
    );
    emojiSignature = _i1.ColumnString(
      'emojiSignature',
      this,
      hasDefault: true,
    );
    hasDoneTutorial = _i1.ColumnBool(
      'hasDoneTutorial',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    lastSeen = _i1.ColumnDateTime(
      'lastSeen',
      this,
      hasDefault: true,
    );
    isAnonymous = _i1.ColumnBool(
      'isAnonymous',
      this,
      hasDefault: true,
    );
  }

  late final UserUpdateTable updateTable;

  late final _i1.ColumnString username;

  late final _i1.ColumnString email;

  late final _i1.ColumnString gender;

  late final _i1.ColumnInt age;

  late final _i1.ColumnString country;

  late final _i1.ColumnInt personaId;

  _i2.PersonaTable? _persona;

  late final _i1.ColumnString emojiSignature;

  late final _i1.ColumnBool hasDoneTutorial;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime lastSeen;

  late final _i1.ColumnBool isAnonymous;

  _i2.PersonaTable get persona {
    if (_persona != null) return _persona!;
    _persona = _i1.createRelationTable(
      relationFieldName: 'persona',
      field: User.t.personaId,
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
    username,
    email,
    gender,
    age,
    country,
    personaId,
    emojiSignature,
    hasDoneTutorial,
    createdAt,
    lastSeen,
    isAnonymous,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'persona') {
      return persona;
    }
    return null;
  }
}

class UserInclude extends _i1.IncludeObject {
  UserInclude._({_i2.PersonaInclude? persona}) {
    _persona = persona;
  }

  _i2.PersonaInclude? _persona;

  @override
  Map<String, _i1.Include?> get includes => {'persona': _persona};

  @override
  _i1.Table<int?> get table => User.t;
}

class UserIncludeList extends _i1.IncludeList {
  UserIncludeList._({
    _i1.WhereExpressionBuilder<UserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(User.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => User.t;
}

class UserRepository {
  const UserRepository._();

  final attachRow = const UserAttachRowRepository._();

  /// Returns a list of [User]s matching the given query parameters.
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
  Future<List<User>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
    UserInclude? include,
  }) async {
    return session.db.find<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [User] matching the given query parameters.
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
  Future<User?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
    UserInclude? include,
  }) async {
    return session.db.findFirstRow<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [User] by its [id] or null if no such row exists.
  Future<User?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    UserInclude? include,
  }) async {
    return session.db.findById<User>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [User]s in the list and returns the inserted rows.
  ///
  /// The returned [User]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<User>> insert(
    _i1.Session session,
    List<User> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<User>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [User] and returns the inserted row.
  ///
  /// The returned [User] will have its `id` field set.
  Future<User> insertRow(
    _i1.Session session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [User]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<User>> update(
    _i1.Session session,
    List<User> rows, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<User>(
      rows,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Updates a single [User]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<User> updateRow(
    _i1.Session session,
    User row, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<User>(
      row,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Updates a single [User] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<User?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<User>(
      id,
      columnValues: columnValues(User.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [User]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<User>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<User>(
      columnValues: columnValues(User.t.updateTable),
      where: where(User.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [User]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<User>> delete(
    _i1.Session session,
    List<User> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<User>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [User].
  Future<User> deleteRow(
    _i1.Session session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<User>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<User>(
      where: where(User.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<User>(
      where: where?.call(User.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserAttachRowRepository {
  const UserAttachRowRepository._();

  /// Creates a relation between the given [User] and [Persona]
  /// by setting the [User]'s foreign key `personaId` to refer to the [Persona].
  Future<void> persona(
    _i1.Session session,
    User user,
    _i2.Persona persona, {
    _i1.Transaction? transaction,
  }) async {
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }
    if (persona.id == null) {
      throw ArgumentError.notNull('persona.id');
    }

    var $user = user.copyWith(personaId: persona.id);
    await session.db.updateRow<User>(
      $user,
      columns: [User.t.personaId],
      transaction: transaction,
    );
  }
}
