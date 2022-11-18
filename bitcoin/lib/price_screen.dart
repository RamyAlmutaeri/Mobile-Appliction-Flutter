import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart' as cur;
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurency = 'AUD';

  DropdownButton<String> getDropdoawnButton() {
    return DropdownButton<String>(
      value: selectedCurency,
      items: getDropdaownItems(),
      onChanged: (value) {
        setState(
          () async {
            selectedCurency = value!;
            getData();
          },
        );
      },
    );
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        selectedCurency = cur.currenciesList[selectedIndex];
        getData();
      },
      children: getIOS(),
    );
  }

  List<DropdownMenuItem<String>> getDropdaownItems() {
    List<DropdownMenuItem<String>> dropdawn = [];

    for (int i = 0; i < cur.currenciesList.length; i++) {
      dropdawn.add(
        DropdownMenuItem(
          child: Text(cur.currenciesList[i]),
          value: cur.currenciesList[i],
        ),
      );
    }
    return dropdawn;
  }

  List<Widget> getIOS() {
    List<Text> dropdawn = [];

    for (String curr in cur.currenciesList) {
      dropdawn.add(
        Text(
          curr,
        ),
      );
    }
    return dropdawn;
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;

    try {
      var data = await cur.CoinData().getCoinData(selectedCurency);
      isWaiting = false;

      setState(
        () {
          coinValues = data;
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: [
              card(
                price: isWaiting ? '?' : coinValues['BTC'],
                selectedCurency: selectedCurency,
                cryptoCurrency: 'BTC',
              ),
              card(
                price: isWaiting ? '?' : coinValues['ETH'],
                selectedCurency: selectedCurency,
                cryptoCurrency: 'ETH',
              ),
              card(
                price: isWaiting ? '?' : coinValues['LTC'],
                selectedCurency: selectedCurency,
                cryptoCurrency: 'LTC',
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getCupertinoPicker() : getDropdoawnButton(),
          ),
        ],
      ),
    );
  }
}

class card extends StatelessWidget {
  const card({
    this.price,
    this.selectedCurency,
    this.cryptoCurrency,
  });

  final String? price;
  final String? selectedCurency;
  final String? cryptoCurrency;

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
          padding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 28.0,
          ),
          child: Text(
            '1 $cryptoCurrency = $price $selectedCurency',
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
