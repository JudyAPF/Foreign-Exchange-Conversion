// conversion.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _baseCurrency = 'USD';
  String _convertedCurrency = 'PHP';
  double _conversionRate = 0.0;

  final Map<String, String> _currencies = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'CAD': 'Canadian Dollar',
    'JPY': 'Japanese Yen',
    'RUB': 'Russian Ruble',
    'PHP': 'Philippine Peso',
    'SAR': 'Saudi Arabian Riyal',
  };

  Future<void> _fetchConversionRate() async {
    const apiKey = 'F6MlKMSSlDIttVGP8Xk9GhUhSo9yRpq9';
    final response = await http.get(Uri.parse(
        'https://open.er-api.com/v6/latest/$_baseCurrency?app_id=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['rates'] != null) {
        setState(() {
          _conversionRate = data['rates'][_convertedCurrency];
        });
      } else {
        throw Exception('Rates data not found');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchConversionRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff9fb874),
        title: const Text('Foreign Exchange Conversion',
            style: TextStyle(
              color: Color(0xffffffff),
            )),
      ),
      backgroundColor: const Color(0xfff0f2f5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Base Currency:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: _baseCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  _baseCurrency = newValue!;
                });
                _fetchConversionRate();
              },
              items: _currencies.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_currencies[value]!),
                );
              }).toList(),
            ),
            const Gap(20),
            const Text(
              'Amount:',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter amount',
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _fetchConversionRate();
              },
            ),
            const Gap(20),
            const Text(
              'Converted Currency:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: _convertedCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  _convertedCurrency = newValue!;
                });
                _fetchConversionRate();
              },
              items: _currencies.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_currencies[value]!),
                );
              }).toList(),
            ),
            const Gap(20),
            const Text(
              'Converted Amount:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              (_amountController.text.isNotEmpty &&
                      double.tryParse(_amountController.text) != null)
                  ? (_conversionRate * double.parse(_amountController.text))
                      .toStringAsFixed(2)
                  : '0.0',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
