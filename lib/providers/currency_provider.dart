import 'package:codechallengetwo/models/currency_conversion.dart';
import 'package:codechallengetwo/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CurrencyProvider extends ChangeNotifier {
  bool state = false;
  final ApiService apiService = ApiService();
  List<CurrencyConversion> _referenceList = [];
  List<CurrencyConversion> _currencyConversionsList = [];
  String onChangeStartDate = '';
  String onChangeEndDate = '';

  String selectedBaseCurrency = 'USD';
  String selectedTargetCurrency = 'EUR';

  final List<String> _availableCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'EGP'];

  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalItems = 0;

  int get totalItems => _totalItems;

  List<CurrencyConversion> get currencyConversions => _currencyConversionsList;

  List<CurrencyConversion> getCurrentPageItems() {
    return paginate();
  }

  List<String> get availableCurrencies => _availableCurrencies;

  Future<void> fetchCurrencyConversions({
    required String startDate,
    required String endDate,
    required String baseCurrency,
    required String targetCurrency,
  }) async {
    state = true;
    notifyListeners();
    try {
      _currencyConversionsList = await apiService.fetchCurrencyConversions(
        startDate: startDate,
        endDate: endDate,
        baseCurrency: baseCurrency,
        targetCurrency: targetCurrency,
      );

      _currentPage = 1;
      _totalItems = _currencyConversionsList.length;
      _referenceList = _currencyConversionsList;
      _currencyConversionsList = paginate();
    } catch (error) {
      debugPrint(error.toString());
    }
    state = false;
    notifyListeners();
  }

  void nextPage() {
    debugPrint('nextPage');
    final maxPage = (_totalItems / _itemsPerPage).ceil();
    if (_currentPage < maxPage) {
      _currentPage++;
      _currencyConversionsList = paginate();
      notifyListeners();
    }
  }

  void previousPage() {
    debugPrint('previousPage');
    if (_currentPage > 1) {
      _currentPage--;
      _currencyConversionsList = paginate();
      notifyListeners();
    }
  }

  List<CurrencyConversion> paginate() {
    debugPrint('paginate');
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    return _referenceList.skip(startIndex).take(_itemsPerPage).toList();
  }
}
