import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tradex_lite/services/stock_api_service.dart';

import '../models/stock.dart';
import '../models/trade.dart';
import '../services/mock_stock_service.dart';

class StockProvider extends ChangeNotifier {
  final MockStockService _mockService = MockStockService();
  final StockApiService _api = StockApiService();

  List<Stock> stocks = [];
  List<Stock> filtered = [];

  /// 📜 Trade History (BONUS)
  List<Trade> tradeHistory = [];

  Timer? _timer;

  StockProvider() {
    _init();
  }

  void _init() {
    stocks = _mockService.getInitialStocks();
    filtered = stocks;
    startLiveUpdates();
  }

  //REAL API FETCH (optional)
  Future<void> fetchRealPrice() async {
    for (var stock in stocks) {
      try {
        double newPrice = await _api.getStockPrice(stock.name);
        stock.change = newPrice - stock.price;
        stock.price = newPrice;
      } catch (e) {
        debugPrint("API Error: $e");
      }
    }
    notifyListeners();
  }

  /// LIVE UPDATES (CONTROLLED)
  void startLiveUpdates({int interval = 2}) {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: interval), (_) {
      for (var stock in stocks) {
        double change = Random().nextDouble() * 4 - 2;
        stock.price += change;
        stock.change = change;
      }

      checkAlerts(); // 🔔 trigger alerts
      filtered = stocks;
      notifyListeners();
    });
  }

  ///  SEARCH
  void search(String query) {
    if (query.isEmpty) {
      filtered = stocks;
    } else {
      filtered = stocks
          .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  /// ADD TRADE (BUY/SELL)
  void addTrade(Trade trade) {
    tradeHistory.insert(0, trade);
    notifyListeners();
  }

  ///  ALERT MOCK
  void checkAlerts() {
    for (var stock in stocks) {
      if (stock.price > 3000) {
        debugPrint("🔔 ${stock.name} crossed 3000!");
      }
    }
  }

  /// MANUAL REFRESH
  Future<void> refresh() async {
    await fetchRealPrice();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
