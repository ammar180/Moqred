import 'package:moqred/backend/db_requests/db_manager.dart';
import 'package:moqred/backend/db_requests/db_service.dart';
import 'package:moqred/backend/schema/dtos/index.dart';
import 'package:moqred/backend/schema/models/transaction.dart';
import 'package:moqred/backend/schema/structs/index.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';

class FetchPersonsOverviewCall {
  static Future<PaginatedResult<PersonOverviewStruct>> call({
    required int page,
    required int perPage,
  }) async {
    final serviceReader = DbReader<PersonOverviewStruct>(
      tableName: 'persons_overview',
      fromMap: (map) => PersonOverviewStruct().fromMap(map),
    );

    return await serviceReader.getPaginated(page: page, pageSize: perPage);
  }
}

class FetchTransactionsCall {
  static Future<PaginatedResult<Transaction>> call({
    required int page,
    required int perPage,
  }) async {
    final serviceReader = DbReader<Transaction>(
      tableName: Transaction.TABLE_NAME,
      fromMap: (map) => Transaction.fromMap(map),
    );

    return await serviceReader.getPaginated(
        page: page, pageSize: perPage, orderBy: 'created', descending: true);
  }
}

class LoadLookupCall {
  static Future<List<Lookup>> call({required String tableName}) async {
    return await SQLiteHelper.db.then((db) async {
      final result = await db.rawQuery(Lookup.getQuery(tableName));
      return result.map(Lookup.fromMap).toList();
    });
  }
}

class FetchElQardBalancesCall {
  static Future<Balance> call() async {
    final sql = '''
SELECT
  SUM(t.amount * tt.sign) AS total_in,
  SUM(CASE WHEN tt.type = 'loan' THEN t.amount ELSE 0 END) 
    - SUM(CASE WHEN tt.type = 'payment' THEN t.amount ELSE 0 END) AS total_out
FROM transactions AS t
JOIN transaction_types AS tt ON t.type = tt.id;
''';

    final db = await SQLiteHelper.db;
    final result = await db.rawQuery(sql);
    return result.map(Balance.fromMap).first;
  }
}
