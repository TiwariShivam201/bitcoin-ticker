import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  CoinData(this.selectedCurrency);

  String selectedCurrency;
  String croptoCurrency;

  Map<String, String> cropto = {};

  Future<dynamic> getCoinData() async {
    for (croptoCurrency in cryptoList) {
      var url = Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/$croptoCurrency/$selectedCurrency?apikey=7CE4BE2F-FC6E-4569-8E76-5B7301495212');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var newValue = jsonDecode(response.body);
        double currency = newValue['rate'];
        cropto[croptoCurrency] = currency.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'APi not working';
      }
    }
    return cropto;
  }
}
