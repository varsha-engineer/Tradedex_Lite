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

    return Scaffold(
      backgroundColor: Colors.transparent,

      /// 🔥 PREMIUM APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Market Watch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          /// 📜 Trade History Button
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

          /// ⚙ Settings
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

          /// 🚪 Logout
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Sign out',
            onPressed: () => _logout(context, auth),
          ),
        ],
      ),

      /// 🌈 GRADIENT BACKGROUND
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        /// 🔄 PULL TO REFRESH
        child: RefreshIndicator(
          onRefresh: () async {
            provider.startLiveUpdates(); // refresh data
            await Future.delayed(const Duration(seconds: 1));
          },

          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            slivers: [
              /// 🔝 HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 📊 INFO CARD
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 22,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your watchlist',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Track market movers, view live pricing, and explore stock details.',
                              style: TextStyle(color: Color(0xFF667085)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// 🔍 SEARCH
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search stocks',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: provider.search,
                      ),

                      const SizedBox(height: 18),

                      /// 📊 COUNT
                      Text(
                        '${provider.filtered.length} stocks available',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 📈 STOCK LIST
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
