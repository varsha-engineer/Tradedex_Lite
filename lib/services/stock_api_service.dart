import 'dart:convert';
import 'package:http/http.dart' as http;

class StockApiService {
  final String apiKey = "YOUR_API_KEY"; // 🔑 Replace this

  Future<double> getStockPrice(String symbol) async {
    try {
      final url =
          "https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return (data["c"] ?? 0).toDouble(); // current price
      } else {
        throw Exception("Failed to fetch price");
      }
    } catch (e) {
      print("API Error: $e");
      return 0;
    }
  }
}
