import 'package:json_annotation/json_annotation.dart';
import 'package:moqred/backend/schema/util/base_model.dart';

part 'transaction_type.g.dart';

@JsonSerializable()
class TransactionType extends BaseModel {
  final String id;
  final String type;
  final int sign;
  final String collectionId;
  final String collectionName;
  final DateTime created;
  final DateTime updated;

  TransactionType({
    required this.id,
    required this.type,
    required this.sign,
    required this.collectionId,
    required this.collectionName,
    required this.created,
    required this.updated,
  });

  static const String TABLE_NAME = 'transaction_types';
  @override
  String get tableName => TABLE_NAME;

  @override
  TransactionType fromMap(Map<String, dynamic> map) =>
      TransactionType.fromMap(map);

  /// Connect the generated [_$TransactionTypeFromJson] function to the `fromJson` factory.
  factory TransactionType.fromMap(Map<String, dynamic> map) =>
      _$TransactionTypeFromJson(map);

  /// Connect the generated [_$TransactionTypeToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toMap() => _$TransactionTypeToJson(this);
}
