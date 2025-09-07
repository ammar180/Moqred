class Lookup {
  final String id;
  final String name;
  Lookup({required this.id, required this.name});
  factory Lookup.fromMap(Map<String, dynamic> data) =>
      Lookup(id: data['id'], name: data['name']);
}
