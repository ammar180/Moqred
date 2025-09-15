import 'package:moqred/backend/db_requests/db_manager.dart';
import 'package:moqred/backend/db_requests/db_service.dart';
import 'package:moqred/backend/schema/dtos/index.dart';
import 'package:moqred/backend/schema/models/index.dart';
import 'package:moqred/backend/schema/structs/index.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';

class FetchPersonsOverviewCall {
  static Future<List<PersonOverviewStruct>> call() async {
    final serviceReader = DbReader<PersonOverviewStruct>(
      tableName: 'persons_overview',
      fromMap: (map) => PersonOverviewStruct().fromMap(map),
    );

    return await serviceReader.getAll(
        orderBy: 'last_transaction', descending: false);
  }
}

class FetchTransactionsCall {
  static Future<PaginatedResult<Transaction>> call({
    required int page,
    required int perPage,
    String? orderBy,
    bool descending = true,
  }) async {
    final serviceReader = DbReader<Transaction>(
      tableName: Transaction.TABLE_NAME,
      fromMap: (map) => Transaction.fromMap(map),
    );


    return await serviceReader.getPaginated(
        includes: [
          Include(
              fields: Person.fields,
              referenceName: Person.TABLE_NAME,
              foreignKey: 'person'),
          Include(
              fields: TransactionType.fields,
              referenceName: TransactionType.TABLE_NAME,
              foreignKey: 'type'),
        ],
        page: page,
        pageSize: perPage,
        orderBy: orderBy ?? 'created',
        descending: descending);
  }
}

class LoadLookupCall {
  static Future<List<Lookup>> call({required String tableName}) async {
    return await SQLiteHelper.db.then((db) async {
      final result = await db.rawQuery(Lookup.getQuery(tableName));
      return result.map(Lookup.fromMap).toList();
    });
  }

  static Future<Lookup?> callById(
      {required String tableName, required String id}) async {
    final serviceReader = DbReader<Lookup>(
      tableName: tableName,
      fromMap: (map) => Lookup.fromMap(map),
    );

    return await serviceReader.getById(id);
  }
}

class FetchElQardBalancesCall {
  static Future<Balance> call() async {
    final db = await SQLiteHelper.db;
    final result = await db.rawQuery(Balance.sql);
    return result.map(Balance.fromMap).first;
  }
}

class InsertTransaction {
  static Future<int> call(
      {required String notes,
      required int amount,
      required String person,
      required String type}) async {
    final serviceWriter = DbWriter<Transaction>();
    try {
      final transaction = Map<String, dynamic>.from(
          {'notes': notes, 'amount': amount, 'person': person, 'type': type});
      return await serviceWriter.insertMap(Transaction.TABLE_NAME, transaction);
    } catch (e) {
      throw Exception('حدث خطأ أثناء إضافة المعاملة');
    }
  }
}

class InsertPerson {
  static Future<int> call(
      {required String name,
      required String phone,
      required String relatedTo,
      required String bio}) async {
    final serviceWriter = DbWriter<Person>();
    try {
      final person = {
        'name': name,
        'phone': phone,
        'related_to': relatedTo,
        'bio': bio,
      };
      return await serviceWriter.insertMap(Person.TABLE_NAME, person);
    } catch (e) {
      throw Exception('حدث خطأ أثناء إضافة الشخص');
    }
  }
}

class RemoveRecord {
  static Future<void> call(
      {required String tableName, required String id}) async {
    final serviceWriter = DbWriter<BaseModel>();
    try {
      await serviceWriter.deleteById(tableName, id);
    } catch (e) {
      throw Exception('حدث خطأ أثناء الحذف');
    }
  }
}

class FetchTransactionTypesCall {
  static Future<List<TransactionType>> call() async {
    final reader = DbReader<TransactionType>(
      tableName: TransactionType.TABLE_NAME,
      fromMap: (map) => TransactionType.fromMap(map),
    );
    return await reader.getAll();
  }
}

class InsertTransactionTypeCall {
  static Future<int> call({
    required String type,
    required String name,
    required int sign,
  }) async {
    final writer = DbWriter<TransactionType>();
    try {
      final data = {
        'type': type,
        'name': name,
        'sign': sign,
      };
      return await writer.insertMap(TransactionType.TABLE_NAME, data);
    } catch (e) {
      throw Exception('حدث خطأ أثناء إضافة نوع المعاملة');
    }
  }
}
