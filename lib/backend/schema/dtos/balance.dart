class Balance {
  final num TotalIn;
  final num TotalOut;

  static String sql = '''
SELECT
  SUM(t.amount * tt.sign) AS total_in,
  SUM(CASE WHEN tt.type = 'loan' THEN t.amount ELSE 0 END) 
    - SUM(CASE WHEN tt.type = 'payment' THEN t.amount ELSE 0 END) AS total_out
FROM transactions AS t
JOIN transaction_types AS tt ON t.type = tt.id;
''';

  num get CurrentBalance => TotalIn + TotalOut;
  Balance({required this.TotalIn, required this.TotalOut});
  factory Balance.fromMap(Map<String, dynamic> data) =>
      Balance(TotalIn: data['total_in'] ?? 0, TotalOut: data['total_out'] ?? 0);
}
