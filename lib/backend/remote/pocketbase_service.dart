import 'package:pocketbase/pocketbase.dart';
import 'package:moqred/utils/secure_config.dart';

class PocketBaseService {
  PocketBaseService({PocketBase? client})
      : _pb = client ?? PocketBase(SecureConfig.pocketBaseUrl);

  final PocketBase _pb;

  Future<T> _retry<T>(Future<T> Function() action, {int retries = 3}) async {
    int attempt = 0;
    Object? lastError;
    while (attempt < retries) {
      try {
        return await action();
      } catch (e) {
        lastError = e;
        attempt++;
        if (attempt >= retries) break;
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      }
    }
    throw lastError ?? Exception('Unknown error');
  }

  Future<void> authenticateAdmin() async {
    await _pb.collection("_superusers").authWithPassword(
          SecureConfig.pocketBaseAdminEmail,
          SecureConfig.pocketBaseAdminPassword,
        );
  }

  Future<List<Map<String, dynamic>>> fetchAllRecords(String collection) async {
    final items = await _retry(
        () => _pb.collection(collection).getFullList(batch: 200, sort: 'id'));
    return items.map((r) => r.data).toList();
  }

  Future<void> deleteAllRecords(String collection) async {
    await _pb.collections.truncate(collection);
  }

  Future<void> createRecords(
      String collection, List<Map<String, dynamic>> records) async {
    const chunk = 50;
    for (var i = 0; i < records.length; i += chunk) {
      final batch = records.sublist(
          i, i + chunk > records.length ? records.length : i + chunk);
      for (final rec in batch) {
        await _retry(() => _pb.collection(collection).create(body: rec));
      }
    }
  }

  Future<Map<String, dynamic>> collectionStats(String collection) async {
    final items =
        await _retry(() => _pb.collection(collection).getFullList(batch: 200));
    DateTime? maxUpdated;
    for (final r in items) {
      final u = r.data['updated'] as String?;
      if (u != null) {
        final dt = DateTime.tryParse(u);
        if (dt != null && (maxUpdated == null || dt.isAfter(maxUpdated))) {
          maxUpdated = dt;
        }
      }
    }
    return {
      'count': items.length,
      'maxUpdated': maxUpdated?.toIso8601String(),
    };
  }
}
