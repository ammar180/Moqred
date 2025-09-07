// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionType _$TransactionTypeFromJson(Map<String, dynamic> json) =>
    TransactionType(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      sign: (json['sign'] as num).toInt(),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$TransactionTypeToJson(TransactionType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'sign': instance.sign,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };
