import 'package:moqred/backend/schema/util/base_model.dart';

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/utils/serialization_util.dart';

class PersonOverviewStruct extends BaseModel {
  PersonOverviewStruct({
    String? id,
    String? name,
    int? loan,
    int? remainder,
    DateTime? lastTransaction,
  })  : id = id,
        _name = name,
        _loan = loan,
        _remainder = remainder,
        _lastTransaction = lastTransaction;

  static String TABLE_NAME = "persons_overview";
  @override
  String get tableName => TABLE_NAME;
  @override
  String? id;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasPersonOverviewCode() => _name != null;
  // "loan" field.
  int? _loan;
  int get loan => _loan ?? 0;
  set loan(int? val) => _loan = val;

  bool hasLoan() => _loan != null;

  // "remainder" field.
  int? _remainder;
  int get remainder => _remainder ?? 0;
  set remainder(int? val) => _remainder = val;

  bool hasRemainder() => _remainder != null;

  // "lastTransaction" field.
  DateTime? _lastTransaction;
  DateTime get lastTransaction => _lastTransaction ?? DateTime(2025);
  set lastTransaction(DateTime? val) => _lastTransaction = val;

  bool hasLastTransaction() => _lastTransaction != null;

  @override
  PersonOverviewStruct fromMap(Map<String, dynamic> data) =>
      PersonOverviewStruct(
        id: castToType<String>(data['id']),
        name: data['name'] as String?,
        loan: data['loan'] as int?,
        remainder: data['remainder'] as int?,
        lastTransaction: DateTime.tryParse(data['last_transaction'] as String),
      );

  PersonOverviewStruct? maybeFromMap(dynamic data) =>
      data is Map ? fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': _name,
        'loan': _loan,
        'remainder': _remainder,
        'last_transaction': _lastTransaction,
      }.withoutNulls;

  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          id,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'loan': serializeParam(
          _loan,
          ParamType.int,
        ),
        'remainder': serializeParam(
          _remainder,
          ParamType.int,
        ),
        'last_transaction': serializeParam(
          _lastTransaction,
          ParamType.String,
        ),
      }.withoutNulls;

  static PersonOverviewStruct fromSerializableMap(Map<String, dynamic> data) =>
      PersonOverviewStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        loan: deserializeParam(
          data['loan'],
          ParamType.int,
          false,
        ),
        remainder: deserializeParam(
          data['remainder'],
          ParamType.int,
          false,
        ),
        lastTransaction: deserializeParam(
          data['last_transaction'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PersonOverviewStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PersonOverviewStruct &&
        id == other.id &&
        name == other.name &&
        loan == other.loan &&
        remainder == other.remainder &&
        lastTransaction == other.lastTransaction;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        loan,
        remainder,
        lastTransaction,
      ]);
}
