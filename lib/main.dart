import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
export 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/stock_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/market_watch_screen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('watchlist');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final stockProvider = StockProvider();
            final settingsProvider = Provider.of<SettingsProvider>(
              context,
              listen: false,
            );
            stockProvider.setSettings(settingsProvider);
            return stockProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
