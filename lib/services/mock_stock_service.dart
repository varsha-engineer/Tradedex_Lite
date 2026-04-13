import 'dart:math';
import '../models/stock.dart';

class MockStockService {
  final Random _random = Random();

  /// 📊 Initial Stock List (REALISTIC)
  List<Stock> getInitialStocks() {
    return [
      Stock(name: "AAPL", price: 150, change: 0),
      Stock(name: "GOOG", price: 2800, change: 0),
      Stock(name: "TSLA", price: 900, change: 0),
      Stock(name: "AMZN", price: 3300, change: 0),
      Stock(name: "MSFT", price: 300, change: 0),
      Stock(name: "NFLX", price: 500, change: 0),
      Stock(name: "META", price: 350, change: 0),
    ];
  }

  /// 🔄 Simulate Live Updates
  List<Stock> updatePrices(List<Stock> stocks) {
    return stocks.map((stock) {
      double change = (_random.nextDouble() * 4) - 2; // -2 to +2
      double newPrice = stock.price + change;

      return Stock(name: stock.name, price: newPrice, change: change);
    }).toList();
  }
}
