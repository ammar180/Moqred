// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      id: json['id'] as String,
      name: (json['name'] ?? "") as String,
      bio: (json['bio'] ?? "") as String,
      phone: (json['phone'] ?? "") as String,
      relatedTo: (json['relatedTo'] ?? "") as String,
      created: ((json['created'] ?? "") as String).isEmpty
          ? DateTime.now()
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? DateTime.now()
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bio': instance.bio,
      'phone': instance.phone,
      'relatedTo': instance.relatedTo,
      'created': instance.created?.toIso8601String() ?? null,
      'updated': instance.updated?.toIso8601String() ?? null,
    };
