import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool darkMode = false;
  int refreshInterval = 2;
  String currency = "INR";

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
}
