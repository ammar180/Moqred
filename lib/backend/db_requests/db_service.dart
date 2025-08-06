import 'package:moqred/backend/db_requests/db_manager.dart';
import 'package:moqred/backend/schema/models/index.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';
import 'package:sqflite/sqflite.dart';

class DbReader<T extends BaseModel> {
  final String tableName;
  final T Function(Map<String, dynamic>) fromMap;

  DbReader({
    required this.tableName,
    required this.fromMap,
  });

  Future<T?> getById(int id) async {
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
}

class DbWriter<T extends BaseModel> {
  Future<int> insert(T item) async {
    final db = await SQLiteHelper.db;
    return await db.insert(item.tableName, item.toMap());
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

  Future<int> deleteById(String tableName, int id) async {
    final db = await SQLiteHelper.db;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
