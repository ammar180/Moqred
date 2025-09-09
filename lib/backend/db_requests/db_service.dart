import 'package:moqred/backend/db_requests/db_manager.dart';
import 'package:moqred/backend/schema/models/index.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';
import '/utils/app_util.dart';
import 'package:sqflite/sqflite.dart';

class DbReader<T> {
  final String tableName;
  final T Function(Map<String, dynamic>) fromMap;

  DbReader({
    required this.tableName,
    required this.fromMap,
  });

  Future<T?> getById(String id) async {
    final db = await SQLiteHelper.db;
    final result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return fromMap(result.first);
    }
    return null;
  }

  Future<List<T>> getAll() async {
    final db = await SQLiteHelper.db;
    final result = await db.query(tableName);
    return result.map(fromMap).toList();
  }

  Future<PaginatedResult<T>> getPaginated({
    required int page,
    int pageSize = 10,
    String? orderBy,
    bool descending = false,
  }) async {
    final db = await SQLiteHelper.db;

    final total = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tableName'),
        ) ??
        0;

    final result = await db.query(
      tableName,
      orderBy:
          orderBy != null ? '$orderBy ${descending ? 'DESC' : 'ASC'}' : null,
      limit: pageSize,
      offset: page * pageSize,
    );

    final items = result.map(fromMap).toList();

    return PaginatedResult<T>(
      items: items,
      totalCount: total,
      currentPage: page,
      pageSize: pageSize,
    );
  }

  Future<PaginatedResult<T>> getPaginatedWithRelation({
    required int page,
    int pageSize = 10,
    String? orderBy,
    bool descending = false,
    List<Include> includes = const [],
  }) async {
    final db = await SQLiteHelper.db;

    final total = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tableName'),
        ) ??
        0;

    final orderClause = orderBy != null
        ? 'ORDER BY tb.$orderBy ${descending ? 'DESC' : 'ASC'}'
        : '';

    final selectParts = ['tb.*'];

    // Relations as JSON objects
    for (final inc in includes) {
      final fields =
          inc.fields.map((f) => "'$f', ${inc.referenceName}.$f").join(', ');
      selectParts.add('JSON_OBJECT($fields) as ${inc.referenceName}');
    }

    final sql = '''
    SELECT ${selectParts.join(', ')}
    FROM $tableName tb
    ${includes.map((inc) => 'LEFT JOIN ${inc.referenceName} ON tb.${inc.foreignKey} = ${inc.referenceName}.id').join('\n')}
    $orderClause
    LIMIT ? OFFSET ?
  ''';

    final result = await db.rawQuery(sql, [pageSize, (page - 1) * pageSize]);

    // Deserialize result rows into models
    final items = result.map((row) {
      // make row mutable
      final map = Map<String, dynamic>.from(row);

      // decode all included JSON objects
      for (final inc in includes) {
        if (map[inc.referenceName] != null) {
          map[inc.referenceName] =
              jsonDecode(map[inc.referenceName].toString());
        }
      }

      // call the provided fromMap to create T
      return fromMap(map);
    }).toList();

    return PaginatedResult<T>(
      items: items,
      totalCount: total,
      currentPage: page,
      pageSize: pageSize,
    );
  }

  Future<List<T>> fromSql(String sql, [List<Object?> params = const []]) async {
    final db = await SQLiteHelper.db;

    final result = await db.rawQuery(sql, params);
    return result.map(fromMap).toList();
  }
}

class Include {
  final String referenceName;
  final List<String> fields;
  final String foreignKey;
  Include(
      {required this.fields,
      required this.referenceName,
      required this.foreignKey});
}

class DbWriter<T extends BaseModel> {
  Future<int> insert(T item) async {
    final db = await SQLiteHelper.db;
    return await db.insert(item.tableName, item.toMap());
  }

  Future<int> insertMap(String tableName, Map<String, dynamic> map) async {
    final db = await SQLiteHelper.db;
    return await db.insert(tableName, map);
  }

  Future<int> update(T item) async {
    if (item.id == null) throw Exception("Cannot update without ID");
    final db = await SQLiteHelper.db;
    return await db.update(
      item.tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(T item) async {
    if (item.id == null) throw Exception("Cannot delete without ID");
    final db = await SQLiteHelper.db;
    return await db
        .delete(item.tableName, where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deleteById(String tableName, String id) async {
    final db = await SQLiteHelper.db;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
