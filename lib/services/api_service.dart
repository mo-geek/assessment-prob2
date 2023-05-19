import 'dart:convert';
import 'package:codechallengetwo/models/currency_conversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.exchangerate.host';

  Future<List<CurrencyConversion>> fetchCurrencyConversions({
    required String startDate,
    required String endDate,
    required String baseCurrency,
    required String targetCurrency,
  }) async {
    final url =
        '$baseUrl/timeseries?start_date=$startDate&end_date=$endDate&base=$baseCurrency&symbols=$targetCurrency';
    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<CurrencyConversion> conversions = [];
      debugPrint('Response: ${data['rates']}');
      data['rates'].forEach((date, rates) {
        final double rate = rates[targetCurrency];
        debugPrint('rate: ${rate}');
        debugPrint('date: $date');
        debugPrint('bc: $baseCurrency');
        debugPrint('tc: $targetCurrency');
        conversions.add(CurrencyConversion(
          date: date.toString(),
          baseCurrency: baseCurrency,
          targetCurrency: targetCurrency,
          rate: rate.toString(),
        ));
      });
      return conversions;
    } else {
      throw Exception('Failed to fetch currency conversions');
    }
  }
}
