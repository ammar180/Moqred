import 'package:moqred/backend/db_requests/db_manager.dart';
import 'package:moqred/utils/internationalization.dart';
import 'package:moqred/backend/db_requests/db_service.dart';
import 'package:moqred/backend/schema/dtos/index.dart';
import 'package:moqred/backend/schema/models/index.dart';
import 'package:moqred/backend/schema/structs/index.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';
import 'package:moqred/utils/nav.dart' show appNavigatorKey;

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
    Map<String, String>? filters,
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
        descending: descending,
        filters: filters);
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
      required String type,
      DateTime? created}) async {
    final serviceWriter = DbWriter<Transaction>();
    try {
      final now = DateTime.now();
      final transaction = Map<String, dynamic>.from({
        'notes': notes,
        'amount': amount,
        'person': person,
        'type': type,
        'created': (created ?? now).toIso8601String(),
        'updated': now.toIso8601String(),
      });
      return await serviceWriter.insertMap(Transaction.TABLE_NAME, transaction);
    } catch (e) {
      throw Exception(AppLocalizations.of(appNavigatorKey.currentContext!)
          .getText('err_add_transaction'));
    }
  }
}

class InsertPerson {
  static Future<int> call(
      {required String name,
      required String phone,
      required String relatedTo,
      required String bio}) async {
    try {
      final person = Person(
        id: '',
        name: name,
        bio: bio,
        phone: phone,
        relatedTo: relatedTo,
      );
      return await DbWriter<Person>().insert(person);
    } catch (e) {
      throw Exception(AppLocalizations.of(appNavigatorKey.currentContext!)
          .getText('err_add_person'));
    }
  }
}

class FetchPersonByIdCall {
  static Future<Person?> call({required String id}) async {
    final reader = DbReader<Person>(
      tableName: Person.TABLE_NAME,
      fromMap: (map) => Person.fromMap(map),
    );
    return await reader.getById(id);
  }
}

class UpdatePersonCall {
  static Future<int> call({required Person person}) async {
    try {
      return await DbWriter<Person>().update(person);
    } catch (e) {
      throw Exception(AppLocalizations.of(appNavigatorKey.currentContext!)
          .getText('err_update_person'));
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
      throw Exception(AppLocalizations.of(appNavigatorKey.currentContext!)
          .getText('err_delete'));
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
      throw Exception(AppLocalizations.of(appNavigatorKey.currentContext!)
          .getText('err_add_tx_type'));
    }
  }
}
