import 'package:moqred/backend/schema/enums/enums.dart' show TransactionType;
import 'package:moqred/utils/internationalization.dart';
import 'package:moqred/utils/nav.dart' show appNavigatorKey;
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
        await DataSeeding.seed(db);
      },
      onOpen: (Database db) async {
        // Check if transaction_types table is empty
        final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM transaction_types'),
        );

        if (count == 0) {
          print("No data found in transaction_types. Running seed.sql...");
          await DataSeeding.seed(db);
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

/// Represents a single seed entry (table + row data)
class SeedEntry {
  final String tableName;
  final Map<String, dynamic> data;

  SeedEntry(this.tableName, this.data);
}

/// Holds all seed data
class DataSeeding {
  static final List<SeedEntry> entries = [
    SeedEntry('transaction_types', {
      'id': TransactionType.loan.value,
      'sign': -1,
      'type': TransactionType.loan.name,
      'name': AppLocalizations.of(appNavigatorKey.currentContext!)
          .getText('type_loan'),
      'created': DateTime.now().toIso8601String(),
      'updated': DateTime.now().toIso8601String(),
    }),
    SeedEntry('transaction_types', {
      'id': TransactionType.payment.value,
      'sign': 1,
      'type': TransactionType.payment.name,
      'name': AppLocalizations.of(appNavigatorKey.currentContext!)
          .getText('type_payment'),
      'created': DateTime.now().toIso8601String(),
      'updated': DateTime.now().toIso8601String(),
    }),
    SeedEntry('transaction_types', {
      'id': TransactionType.filling.value,
      'sign': 1,
      'type': TransactionType.filling.name,
      'name': AppLocalizations.of(appNavigatorKey.currentContext!)
          .getText('type_filling'),
      'created': DateTime.now().toIso8601String(),
      'updated': DateTime.now().toIso8601String(),
    }),
    SeedEntry('transaction_types', {
      'id': TransactionType.donate.value,
      'sign': 1,
      'type': TransactionType.donate.name,
      'name': AppLocalizations.of(appNavigatorKey.currentContext!).getText('type_donate'),
      'created': DateTime.now().toIso8601String(),
      'updated': DateTime.now().toIso8601String(),
    }),
  ];

  /// Seeds all defined entries into the database
  static Future<void> seed(Database db) async {
    await db.transaction((txn) async {
      for (final entry in entries) {
        await txn.insert(
          entry.tableName,
          entry.data,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });
  }
}
