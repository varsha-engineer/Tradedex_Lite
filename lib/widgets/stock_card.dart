import 'package:flutter/material.dart';
import '../models/stock.dart';

class StockCard extends StatelessWidget {
  final Stock stock;
  final VoidCallback onTap;

  const StockCard({super.key, required this.stock, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isProfit = stock.change >= 0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final changeColor = isProfit
        ? const Color(0xFF4CAF50)
        : const Color(0xFFF44336);
    final badgeColor = isProfit
        ? const Color(0x1F4CAF50)
        : const Color(0x1FF44336);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? const Color.fromRGBO(0, 0, 0, 0.3)
                    : const Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${stock.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : const Color(0xFF61718B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isProfit ? 'Up' : 'Down',
                            style: TextStyle(
                              color: changeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Intraday',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${stock.change.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: changeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Icon(
                    isProfit
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: changeColor,
                    size: 22,
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
