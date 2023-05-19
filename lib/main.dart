// main.dart
import 'package:codechallengetwo/providers/currency_provider.dart';
import 'package:codechallengetwo/screens/conversion_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrencyProvider(),
      child: MaterialApp(
        title: 'Currency Converter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ConversionScreen(),
      ),
    );
  }
}
