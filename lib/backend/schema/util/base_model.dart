abstract class BaseModel {
  String? id;

  /// Used by DbWriter
  Map<String, dynamic> toMap();

  /// Used by DbReader
  BaseModel fromMap(Map<String, dynamic> map);

  /// Used by DbReader
  String get tableName;
}
