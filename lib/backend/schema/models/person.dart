import 'package:json_annotation/json_annotation.dart';
import 'package:moqred/backend/schema/util/base_model.dart';

part 'person.g.dart';

@JsonSerializable()
class Person extends BaseModel {
  final String id;
  final String name;
  final String bio;
  final String phone;
  final String relatedTo;
  final String collectionId;
  final String collectionName;
  final DateTime created;
  final DateTime updated;

  Person({
    required this.id,
    required this.name,
    required this.bio,
    required this.phone,
    required this.relatedTo,
    required this.collectionId,
    required this.collectionName,
    required this.created,
    required this.updated,
  });

  static const String TABLE_NAME = 'persons';
  @override
  String get tableName => TABLE_NAME;

  @override
  Person fromMap(Map<String, dynamic> map) => Person.fromMap(map);

  /// Connect the generated [_$PersonFromJson] function to the `fromJson` factory.
  factory Person.fromMap(Map<String, dynamic> map) =>
      _$PersonFromJson(map);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toMap() => _$PersonToJson(this);
}
