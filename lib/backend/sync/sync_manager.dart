import 'package:moqred/backend/db_requests/db_manager.dart';
import 'package:moqred/backend/remote/pocketbase_service.dart';
import 'package:moqred/backend/schema/models/index.dart';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm, Sqflite;

class SyncManager {
  SyncManager({PocketBaseService? remote}) : _remote = remote ?? PocketBaseService();

  final PocketBaseService _remote;

  // Define upload order: parents first then children
  static const List<String> parentTables = [
    TransactionType.TABLE_NAME,
    Person.TABLE_NAME,
  ];
  static List<String> childTables = [
    Transaction.TABLE_NAME,
  ];

  static Map<String, String> collectionMap = {
    TransactionType.TABLE_NAME: 'transaction_types',
    Person.TABLE_NAME: 'persons',
    Transaction.TABLE_NAME: 'transactions',
  };

  Future<void> backupToPocketBase() async {
    final db = await SQLiteHelper.db;
    await _remote.authenticateAdmin();

    // Truncate remote in correct order: children first
    for (final table in [...childTables, ...parentTables].map((t) => collectionMap[t]!)) {
      await _remote.deleteAllRecords(table);
    }

    // Read and push parents then children
    // Helper to read all rows as maps
    Future<List<Map<String, Object?>>> readAll(String table) async {
      return await db.query(table);
    }

    Future<void> pushAll(String table) async {
      final rows = await readAll(table);
      // PocketBase expects string values for ids and references
      final normalized = rows.map((r) => r.map((k, v) => MapEntry(k, v))).toList();
      await _remote.createRecords(collectionMap[table]!, normalized.cast<Map<String, dynamic>>());
    }

    for (final table in parentTables) {
      await pushAll(table);
    }
    for (final table in childTables) {
      await pushAll(table);
    }
  }

  Future<void> restoreFromPocketBase() async {
    final db = await SQLiteHelper.db;
    await _remote.authenticateAdmin();

    await db.transaction((txn) async {
      Future<void> clearTable(String table) async {
        await txn.delete(table);
      }

      // Clear children then parents
      for (final table in childTables) {
        await clearTable(table);
      }
      for (final table in parentTables) {
        await clearTable(table);
      }

      Future<void> insertAll(String table) async {
        final items = await _remote.fetchAllRecords(collectionMap[table]!);
        for (final item in items) {
          // Map PocketBase default fields
          final map = Map<String, Object?>.from(item);
          // PocketBase adds system fields; keep only known columns
          final allowed = _allowedColumns(table);
          final filtered = <String, Object?>{};
          for (final c in allowed) {
            if (map.containsKey(c)) filtered[c] = map[c];
          }
          await txn.insert(table, filtered, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }

      for (final table in parentTables) {
        await insertAll(table);
      }
      for (final table in childTables) {
        await insertAll(table);
      }
    });
  }

  Future<Map<String, dynamic>> syncStatus() async {
    final db = await SQLiteHelper.db;
    await _remote.authenticateAdmin();

    Future<Map<String, Object?>> localStats(String table) async {
      final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table')) ?? 0;
      final res = await db.rawQuery('SELECT MAX(updated) as max_updated FROM $table');
      final maxUpdated = (res.isNotEmpty ? res.first['max_updated'] : null) as String?;
      return {'count': count, 'maxUpdated': maxUpdated};
    }

    final result = <String, dynamic>{};
    for (final table in [...parentTables, ...childTables]) {
      final local = await localStats(table);
      final remote = await _remote.collectionStats(collectionMap[table]!);
      result[table] = {
        'local': local,
        'remote': remote,
        'inSync': local['count'] == remote['count'] && (local['maxUpdated'] == remote['maxUpdated'] || local['maxUpdated'] == null || remote['maxUpdated'] == null),
      };
    }
    return result;
  }

  List<String> _allowedColumns(String table) {
    if (table == TransactionType.TABLE_NAME) return TransactionType.fields;
    if (table == Person.TABLE_NAME) return Person.fields;
    if (table == Transaction.TABLE_NAME) return ['id', 'amount', 'created', 'updated', 'notes', 'person', 'type'];
    return [];
  }
}


