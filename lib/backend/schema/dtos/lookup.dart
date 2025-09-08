class Lookup {
  final String id;
  final String name;
  Lookup({required this.id, required this.name});

  Lookup fromMap(Map<String, dynamic> map) => Lookup.fromMap(map);
  factory Lookup.fromMap(Map<String, dynamic> data) =>
      Lookup(id: data['id'], name: data['name']);

  static String getQuery(String tableName) =>
      "SELECT id, name FROM $tableName ORDER BY name ASC";
}
