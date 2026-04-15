import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/stock_card.dart';
import '../widgets/settings_modal.dart';
import 'login_screen.dart';
import 'stock_detail_screen.dart';
import 'trade_history_screen.dart';

class MarketWatchScreen extends StatelessWidget {
  const MarketWatchScreen({super.key});

  void _logout(BuildContext context, AuthProvider auth) {
    auth.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,

      /// APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
        title: const Text(
          'Market Watch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          /// Trade History Button
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "Trade History",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TradeHistoryScreen()),
              );
            },
          ),

          ///  Settings
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const SettingsModal(),
              );
            },
          ),

          ///  Logout
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Sign out',
            onPressed: () => _logout(context, auth),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        ///  PULL TO REFRESH
        child: RefreshIndicator(
          onRefresh: () async {
            provider.startLiveUpdates(); // refresh data
            await Future.delayed(const Duration(seconds: 1));
          },

          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            slivers: [
              ///  HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ? const Color.fromRGBO(0, 0, 0, 0.3)
                                  : const Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your watchlist',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Track market movers, view live pricing, and explore stock details.',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey.shade400
                                    : const Color(0xFF667085),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      ///  SEARCH
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search stocks',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: isDarkMode
                              ? const Color(0xFF334155)
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: provider.search,
                      ),

                      const SizedBox(height: 18),

                      ///  COUNT
                      Text(
                        '${provider.filtered.length} stocks available',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : const Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///  STOCK LIST
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final stock = provider.filtered[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: StockCard(
                      stock: stock,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StockDetailScreen(stock: stock),
                          ),
                        );
                      },
                    ),
                  );
                }, childCount: provider.filtered.length),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );
  }
}
