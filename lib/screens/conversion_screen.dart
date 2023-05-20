import 'package:codechallengetwo/providers/currency_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';

class ConversionScreen extends StatefulWidget {
  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  String onChangeEndDate = '';

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          DateTimePicker(
            type: DateTimePickerType.date,
            dateMask: 'd MMM, yyyy',
            initialValue: DateTime.now().toString(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: const Icon(Icons.event),
            dateLabelText: 'Start Date',
            onChanged: (val) => setState(() {
              currencyProvider.onChangeStartDate = val;
            }),
          ),
          DateTimePicker(
            type: DateTimePickerType.date,
            dateMask: 'd MMM, yyyy',
            initialValue: DateTime.now().toString(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: const Icon(Icons.event),
            dateLabelText: 'End Date',
            onChanged: (val) => setState(() {
              currencyProvider.onChangeEndDate = val;
            }),
          ),
          DropdownButtonFormField<String>(
            value: currencyProvider.selectedBaseCurrency,
            onChanged: (newValue) {
              setState(() {
                currencyProvider.selectedBaseCurrency = newValue!;
              });
            },
            items: currencyProvider.availableCurrencies
                .map<DropdownMenuItem<String>>(
              (currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              },
            ).toList(),
            decoration: const InputDecoration(labelText: 'Base Currency'),
          ),
          DropdownButtonFormField<String>(
            value: currencyProvider.selectedTargetCurrency,
            onChanged: (newValue) {
              setState(() {
                currencyProvider.selectedTargetCurrency = newValue!;
              });
            },
            items: currencyProvider.availableCurrencies
                .map<DropdownMenuItem<String>>(
              (currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              },
            ).toList(),
            decoration: const InputDecoration(labelText: 'Target Currency'),
          ),
          const SizedBox(height: 16.0),
          currencyProvider.state
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                )
              : ElevatedButton(
                  onPressed: () {
                    final startDate = currencyProvider.onChangeStartDate;
                    final endDate = currencyProvider.onChangeEndDate;
                    final baseCurrency = currencyProvider.selectedBaseCurrency;
                    final targetCurrency =
                        currencyProvider.selectedTargetCurrency;

                    currencyProvider.fetchCurrencyConversions(
                      startDate: startDate,
                      endDate: endDate,
                      baseCurrency: baseCurrency,
                      targetCurrency: targetCurrency,
                    );
                  },
                  child: const Text('Submit Conversions'),
                ),
          const SizedBox(height: 16.0),
          if (currencyProvider.currencyConversions.isNotEmpty)
            Consumer<CurrencyProvider>(
              builder: (context, provider, _) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currencyProvider.currencyConversions.length,
                  itemBuilder: (BuildContext context, index) {
                    final item = currencyProvider.currencyConversions[index];
                    return ListTile(
                      title: Text('Date: ${item.date}'),
                      subtitle: Text(
                        '1 ${item.baseCurrency} = ${item.rate} ${item.targetCurrency}',
                      ),
                    );
                  },
                );
              },
            ),
          if (currencyProvider.currencyConversions.isNotEmpty)
            Column(
              children: [
                ElevatedButton(
                  onPressed: currencyProvider.previousPage,
                  child: const Text('Previous Page'),
                ),
                ElevatedButton(
                  onPressed: currencyProvider.nextPage,
                  child: const Text('Next Page'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
