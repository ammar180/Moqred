class Balance {
  final num TotalIn;
  final num TotalOut;
  num get CurrentBalance => TotalIn + TotalOut;
  Balance({required this.TotalIn, required this.TotalOut});
  factory Balance.fromMap(Map<String, dynamic> data) =>
      Balance(TotalIn: data['total_in'] ?? 0, TotalOut: data['total_out'] ?? 0);
}
