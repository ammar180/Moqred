import 'package:moqred/backend/db_requests/db_service.dart';
import 'package:moqred/backend/schema/structs/index.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';

class FetchPersonsOverviewCall {
  static Future<PaginatedResult<PersonOverviewStruct>> call({
    required int page,
    required int perPage,
  }) async {
    final serviceReader = DbReader<PersonOverviewStruct>(
      tableName: 'notes',
      fromMap: (map) => PersonOverviewStruct().fromMap(map),
    );

    return await serviceReader.getPaginated(page: page, pageSize: perPage);
  }
}
