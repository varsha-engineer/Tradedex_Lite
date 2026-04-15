import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stock.dart';
import '../providers/stock_provider.dart';
import '../providers/settings_provider.dart';
import '../models/trade.dart';

class StockDetailScreen extends StatefulWidget {
  final Stock stock;

  const StockDetailScreen({super.key, required this.stock});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  String selectedRange = "1D";

  List<FlSpot> generateChart() {
    final random = Random(widget.stock.name.hashCode + selectedRange.hashCode);

    return List.generate(
      20,
      (i) => FlSpot(i.toDouble(), 60 + random.nextDouble() * 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stock = widget.stock;
    final settings = Provider.of<SettingsProvider>(context);
    final chartData = generateChart();
    final isProfit = stock.change >= 0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final openPrice = stock.price * (isProfit ? 0.96 : 1.03);
    final highPrice = stock.price * (isProfit ? 1.05 : 1.01);
    final lowPrice = stock.price * (isProfit ? 0.96 : 0.92);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(stock.name),
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

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///  STOCK NAME
              Text(
                stock.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              ///  PRICE + CHANGE
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    settings.formatPrice(stock.price),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isProfit
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${stock.change.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isProfit
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// TIME FILTER (INTERACTIVE)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["1D", "1W", "1M", "1Y", "5Y"].map((e) {
                  final isSelected = selectedRange == e;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedRange = e);
                    },
                    child: Chip(
                      label: Text(e),
                      backgroundColor: isSelected
                          ? Colors.blue.shade100
                          : isDarkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade200,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              ///  CHART
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 260,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartData,
                              isCurved: true,
                              color: isProfit ? Colors.green : Colors.red,
                              barWidth: 4,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: isProfit
                                    ? const Color.fromRGBO(76, 175, 80, 0.15)
                                    : const Color.fromRGBO(244, 67, 54, 0.15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ///  PRICE DETAILS
              Text(
                'Today\'s price action',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  _DetailTile(
                    label: 'Open',
                    value: settings.formatPrice(openPrice),
                  ),
                  const SizedBox(width: 12),
                  _DetailTile(
                    label: 'High',
                    value: settings.formatPrice(highPrice),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _DetailTile(
                    label: 'Low',
                    value: settings.formatPrice(lowPrice),
                  ),
                  const SizedBox(width: 12),
                  _DetailTile(
                    label: 'Close',
                    value: settings.formatPrice(stock.price),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ///  COMPANY INFO
              Text(
                "About",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "This company is a leading global tech firm focusing on innovation, AI, and digital platforms.",
                style: TextStyle(
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              ///  BUY / SELL BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Provider.of<StockProvider>(
                          context,
                          listen: false,
                        ).addTrade(
                          Trade(
                            type: "BUY",
                            price: stock.price,
                            qty: 1,
                            status: "Completed",
                            date: DateTime.now(),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Stock Bought")),
                        );
                      },
                      child: const Text("BUY"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Provider.of<StockProvider>(
                          context,
                          listen: false,
                        ).addTrade(
                          Trade(
                            type: "SELL",
                            price: stock.price,
                            qty: 1,
                            status: "Completed",
                            date: DateTime.now(),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Stock Sold")),
                        );
                      },
                      child: const Text("SELL"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;

  const _DetailTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? const Color.fromRGBO(0, 0, 0, 0.3)
                  : const Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDarkMode
                    ? Colors.grey.shade400
                    : const Color(0xFF667085),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
