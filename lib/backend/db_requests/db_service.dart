import 'package:moqred/backend/db_requests/db_manager.dart';
import 'package:moqred/backend/schema/models/index.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';
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
    List<Include> includes = const [],
  }) async {
    final db = await SQLiteHelper.db;

    final total = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tableName'),
        ) ??
        0;

    if (includes.isEmpty) {
      // Simple query
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
    } else {
      // Join query
      final orderClause = orderBy != null
          ? 'ORDER BY tb.$orderBy ${descending ? 'DESC' : 'ASC'}'
          : '';

      final selectParts = ['tb.*'];
      for (final inc in includes) {
        for (final f in inc.fields) {
          selectParts.add('${inc.referenceName}.$f AS ${inc.referenceName}_$f');
        }
      }

      final sql = '''
      SELECT ${selectParts.join(', ')}
      FROM $tableName tb
      ${includes.map((inc) => 'LEFT JOIN ${inc.referenceName} ON tb.${inc.foreignKey} = ${inc.referenceName}.id').join('\n')}
      $orderClause
      LIMIT ? OFFSET ?
      ''';

      final result = await db.rawQuery(sql, [pageSize, (page - 1) * pageSize]);

      final items = result.map((row) {
        final map = Map<String, dynamic>.from(row);

        for (final inc in includes) {
          final rel = <String, dynamic>{};
          var hasValue = false;

          for (final f in inc.fields) {
            final key = '${inc.referenceName}_$f';
            if (map.containsKey(key)) {
              rel[f] = map[key];
              if (map[key] != null) {
                hasValue = true;
              }
              map.remove(key);
            }
          }

          if (hasValue) {
            map[inc.referenceName] = rel;
          }
        }

        return fromMap(map);
      }).toList();

      return PaginatedResult<T>(
        items: items,
        totalCount: total,
        currentPage: page,
        pageSize: pageSize,
      );
    }
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
