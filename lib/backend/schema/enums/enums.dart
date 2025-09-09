import 'package:collection/collection.dart';

enum TransactionType {
  loan('a3791c76'),
  payment('b7a4dbfa'),
  filling('bcf40d21');

  final String value;
  const TransactionType(this.value);

  static TransactionType? fromValue(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      // ignore: cast_from_null_always_fails
      orElse: () => null as TransactionType, // returns null if not found
    );
  }
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    default:
      return null;
  }
}
