import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool darkMode = false;
  int refreshInterval = 2;
  String currency = "INR";

  // Currency conversion rates (mock - in real app, fetch from API)
  static const double usdToInrRate = 83.0; // 1 USD = 83 INR

  void toggleTheme() {
    darkMode = !darkMode;
    notifyListeners();
  }

  void changeInterval(int val) {
    refreshInterval = val;
    notifyListeners();
  }

  void changeCurrency(String val) {
    currency = val;
    notifyListeners();
  }

  // Convert price based on selected currency
  double convertPrice(double priceInr) {
    if (currency == "USD") {
      return priceInr / usdToInrRate;
    }
    return priceInr;
  }

  // Get currency symbol
  String get currencySymbol {
    return currency == "USD" ? "\$" : "₹";
  }

  // Format price with currency
  String formatPrice(double priceInr) {
    final convertedPrice = convertPrice(priceInr);
    return '${currencySymbol}${convertedPrice.toStringAsFixed(2)}';
  }
}
