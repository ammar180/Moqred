// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toInt(),
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
      notes: json['notes'] as String,
      person: json['person'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'person': instance.person,
      'notes': instance.notes,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };
