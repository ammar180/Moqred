import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
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

    // Check if the DB exists
    final exists = await databaseExists(path);

    if (!exists) {
      print("Copying pre-populated DB from assets...");

      // Load from asset and write to local
      ByteData data = await rootBundle.load('assets/app.db');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Database already exists.");
    }
    return await openDatabase(path, version: 1);
  }
}

