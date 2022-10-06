import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  String newCurrency;

  DropdownButton<String> androidDropButton() {
    List<DropdownMenuItem<String>> newList = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      newList.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: newList,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getCoinData();
        });
      },
    );
  }

  CupertinoPicker getPickerForIso() {
    List<Text> pickerItem = [];

    for (String currency in currenciesList) {
      var newTitle = Text(currency);
      pickerItem.add(newTitle);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedValue) {
        setState(() {
          selectedCurrency = currenciesList[selectedValue];
          getCoinData();
        });
      },
      children: pickerItem,
    );
  }

  String currencyInUSD = '?';

  @override
  void initState() {
    super.initState();
    getCoinData();
  }

  Map<String, String> cropto = {};

  bool isWaiting = false;

  void getCoinData() async {
    isWaiting = true;
    try {
      var coinData = await CoinData(selectedCurrency).getCoinData();
      isWaiting = false;

      setState(() {
        cropto = coinData;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ReusebleCard(
            currencyInUSD: isWaiting ? '?' : cropto['BTC'],
            selectedCurrency: selectedCurrency,
            currency: 'BTC',
          ),
          ReusebleCard(
            currencyInUSD: isWaiting ? '?' : cropto['ETH'],
            selectedCurrency: selectedCurrency,
            currency: 'ETH',
          ),
          ReusebleCard(
            currencyInUSD: isWaiting ? '?' : cropto['LTC'],
            selectedCurrency: selectedCurrency,
            currency: 'LTC',
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getPickerForIso() : androidDropButton(),
          ),
        ],
      ),
    );
  }
}

class ReusebleCard extends StatelessWidget {
  const ReusebleCard({
    @required this.currencyInUSD,
    @required this.selectedCurrency,
    @required this.currency,
  });

  final String currencyInUSD;
  final String selectedCurrency;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $currency = $currencyInUSD $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
