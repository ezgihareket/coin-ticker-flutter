import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '...' : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '🤑 Coin Ticker',
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Color(0xFF1F1E2A),
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  imageSelect() {
    if (cryptoCurrency == 'BTC') {
      return Image(
        height: 50,
        width: 50,
        image: AssetImage(
          'images/bitcoin.png',
        ),
      );
    } else if (cryptoCurrency == 'ETH') {
      return Image(
        height: 50,
        width: 50,
        image: AssetImage(
          'images/ethereum.png',
        ),
      );
    } else if (cryptoCurrency == 'LTC') {
      return Image(
        height: 50,
        width: 50,
        image: AssetImage(
          'images/litecoin.png',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 18.0, 5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Color(0xFF1F1E2A),
            elevation: 8.0,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 28.0),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2, top: 5),
                        child: Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: imageSelect(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$cryptoCurrency',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Amount 1',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 110,
                                  ),
                                  Text(
                                    '$value $selectedCurrency',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
