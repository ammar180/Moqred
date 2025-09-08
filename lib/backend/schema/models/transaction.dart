import 'package:moqred/backend/schema/models/index.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction extends BaseModel {
  @override
  final String? id;
  final int amount;

  final String type;
  final String person;

  final String notes;
  final DateTime created;
  final DateTime updated;

  Transaction({
    this.id,
    required this.amount,
    required this.created,
    required this.updated,
    required this.notes,
    required this.person,
    required this.type,
    this.personDetails,
    this.typeDetails,
  });

  static const String TABLE_NAME = 'transactions';
  @override
  String get tableName => TABLE_NAME;

  String get formattedAmount {
    final absAmount = amount.abs();
    final sign = amount < 0 ? '-' : '';
    return '$sign\$${(absAmount / 100).toStringAsFixed(2)}';
  }

  final Person? personDetails;
  final TransactionType? typeDetails;

  @override
  Transaction fromMap(Map<String, dynamic> map) => Transaction.fromMap(map);

  /// Connect the generated [_$TransactionFromJson] function to the `fromJson` factory.
  factory Transaction.fromMap(Map<String, dynamic> map) =>
      _$TransactionFromJson(map);

  /// Connect the generated [_$TransactionToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toMap() => _$TransactionToJson(this);
}
