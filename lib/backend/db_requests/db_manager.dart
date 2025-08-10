import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class SQLiteHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        print("Creating database from schema.sql...");
        await _runSqlFile(db, 'assets/schema.sql');

        print("Seeding initial data from seed.sql...");
        await _runSqlFile(db, 'assets/seed.sql');
      },
      onOpen: (Database db) async {
        // Check if transaction_types table is empty
        final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM transaction_types'),
        );

        if (count == 0) {
          print("No data found in transaction_types. Running seed.sql...");
          await _runSqlFile(db, 'assets/seed.sql');
        } else {
          print("Data already present. Skipping seed.");
        }
      },
    );
  }

  static Future<void> _runSqlFile(Database db, String assetPath) async {
    final sql = await rootBundle.loadString(assetPath);

    final statements =
        sql.split(';').map((s) => s.trim()).where((s) => s.isNotEmpty);

    await db.transaction((txn) async {
      for (final stmt in statements) {
        try {
          print("Executing: $stmt");
          await txn.execute(stmt);
        } catch (e) {
          print("Error running statement: $stmt");
          print("Error: $e");
        }
      }
    });
  }
}
