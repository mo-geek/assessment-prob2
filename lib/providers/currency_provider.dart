import 'package:codechallengetwo/models/currency_conversion.dart';
import 'package:codechallengetwo/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CurrencyProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  List<CurrencyConversion> _currencyConversions = [];
  String onChangeStartDate = '';
  String onChangeEndDate = '';
  final TextEditingController baseCurrencyController = TextEditingController();
  final TextEditingController targetCurrencyController =
      TextEditingController();
  int _startIndex = 0;
  final int _perPage = 10;

  List<CurrencyConversion> get currencyConversions => _currencyConversions;

  List<CurrencyConversion> getCurrentPageItems() {
    return _currencyConversions.sublist(
      _startIndex,
      _startIndex + _perPage,
    );
  }

  Future<void> fetchCurrencyConversions({
    required String startDate,
    required String endDate,
    required String baseCurrency,
    required String targetCurrency,
  }) async {
    debugPrint('startDate: $startDate ');
    debugPrint('endDate: $endDate ');
    debugPrint('baseCurrency: $baseCurrency ');
    debugPrint('targetCurrency: $targetCurrency ');
    try {
      _currencyConversions = await apiService.fetchCurrencyConversions(
        startDate: startDate,
        endDate: endDate,
        baseCurrency: baseCurrency,
        targetCurrency: targetCurrency,
      );
      print("currency conversion list: $_currencyConversions");
      _startIndex = 0;
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  void nextPage() {
    if (_startIndex + _perPage < _currencyConversions.length) {
      _startIndex += _perPage;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_startIndex - _perPage >= 0) {
      _startIndex -= _perPage;
      notifyListeners();
    }
  }
}
