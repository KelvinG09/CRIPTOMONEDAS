import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double> getExchangeRate(String base, String quote) async {
  final String url = 'https://rest.coinapi.io/v1/exchangerate/$base/$quote';
  final Map<String, String> headers = {
    'X-CoinAPI-Key': '03521bde-71de-4adf-bb4b-3de99b62c59b',
    'Accept': 'application/json',
  };

  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['rate'] * 1.0;
  } else {
    throw Exception('Failed to load exchange rate: ${response.statusCode}');
  }
}
