import 'package:collection/collection.dart';

enum TransactionStatus {
  approved,
  rejected,
  pending,
  edited,
}

enum TransactionTitles {
  Leave,
  Mission,
}

enum TransactionType {
  CasualLeave,
  RegularLeave,
  HalfDay,
  QuarterDay,
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
    case (TransactionStatus):
      return TransactionStatus.values.deserialize(value) as T?;
    case (TransactionTitles):
      return TransactionTitles.values.deserialize(value) as T?;
    case (TransactionType):
      return TransactionType.values.deserialize(value) as T?;
    default:
      return null;
  }
}
