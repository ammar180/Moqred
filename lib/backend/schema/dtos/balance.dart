class Balance {
  final num TotalIn;
  final num TotalOut;
  num get CurrentBalance => TotalIn.abs() + TotalOut.abs();
  Balance({required this.TotalIn, required this.TotalOut});
  factory Balance.fromMap(Map<String, dynamic> data) =>
      Balance(TotalIn: data['total_in'], TotalOut: data['total_out']);
}
