// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toInt(),
      created: json['created'].runtimeType == DateTime
          ? json['created']
          : DateTime.parse(json['created'] as String),
      updated: json['updated'].runtimeType == DateTime
          ? json['updated']
          : DateTime.parse(json['updated'] as String),
      notes: (json['notes'] ?? "") as String,
      person: json['person'] as String,
      type: json['type'] as String,
      personDetails: json[Person.TABLE_NAME] == null
          ? null
          : Person.fromMap(json[Person.TABLE_NAME]),
      typeDetails: json[TransactionType.TABLE_NAME] == null
          ? null
          : TransactionType.fromMap(json[TransactionType.TABLE_NAME]),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'person': instance.person,
      'notes': instance.notes,
      'created': instance.created,
      'updated': instance.updated,
      'personName': instance.personName,
      'typeName': instance.typeName,
      Person.TABLE_NAME: instance.personDetails?.toMap(),
      TransactionType.TABLE_NAME: instance.typeDetails?.toMap(),
    };
