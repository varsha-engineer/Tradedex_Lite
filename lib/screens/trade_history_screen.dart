import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';

class TradeHistoryScreen extends StatelessWidget {
  const TradeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Trade History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
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
        child: provider.tradeHistory.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 80,
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No trades yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your trading activity will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode
                          ? Colors.grey.shade500
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Trades',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${provider.tradeHistory.length} transaction${provider.tradeHistory.length > 1 ? 's' : ''}',
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
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final trade = provider.tradeHistory[index];
                        final settings = Provider.of<StockProvider>(
                          context,
                          listen: false,
                        ).settings;
                        final isBuy = trade.type == 'BUY';
                        final totalAmount = trade.price * trade.qty;
                        final date = DateFormat(
                          'dd MMM, hh:mm a',
                        ).format(trade.date);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? const Color.fromRGBO(0, 0, 0, 0.3)
                                      : const Color.fromRGBO(0, 0, 0, 0.06),
                                  blurRadius: 18,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Trade Type Icon
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isBuy
                                        ? Colors.green.shade50
                                        : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    isBuy
                                        ? Icons.trending_up_rounded
                                        : Icons.trending_down_rounded,
                                    color: isBuy
                                        ? Colors.green.shade600
                                        : Colors.red.shade600,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                /// Trade Details - Made more flexible
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${trade.type} ${trade.qty} units',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: trade.status == 'Completed'
                                                  ? Colors.green.shade50
                                                  : Colors.orange.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              trade.status,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    trade.status == 'Completed'
                                                    ? Colors.green.shade700
                                                    : Colors.orange.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDarkMode
                                              ? Colors.grey.shade500
                                              : const Color(0xFF98A2B3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// Price - Fixed width to prevent overflow
                                SizedBox(
                                  width: 80,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        settings.formatPrice(totalAmount),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '@ ${settings.formatPrice(trade.price)}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDarkMode
                                              ? Colors.grey.shade500
                                              : const Color(0xFF98A2B3),
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }, childCount: provider.tradeHistory.length),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
      ),
    );
  }
}
