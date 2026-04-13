class Trade {
  final String type; // BUY / SELL
  final double price;
  final int qty;
  final String status; // Completed / Pending
  final DateTime date;

  Trade({
    required this.type,
    required this.price,
    required this.qty,
    required this.status,
    required this.date,
  });
}
