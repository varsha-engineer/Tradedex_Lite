import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';

class TradeHistoryScreen extends StatelessWidget {
  const TradeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Trade History")),
      body: ListView.builder(
        itemCount: provider.tradeHistory.length,
        itemBuilder: (_, i) {
          final t = provider.tradeHistory[i];

          return ListTile(
            title: Text("${t.type} - ${t.qty}"),
            subtitle: Text("₹${t.price}"),
            trailing: Text(t.status),
          );
        },
      ),
    );
  }
}
