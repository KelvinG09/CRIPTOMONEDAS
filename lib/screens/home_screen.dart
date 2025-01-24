import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:convertidor_criptomoneda/data.dart';

import '../services/exchange_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? selectedCurrency = "DOP";
  double? rate;

  Future<void> updateExchangeRate() async {
    try {
      double fetchedRate = await getExchangeRate('BTC', selectedCurrency!);
      setState(() {
        rate = fetchedRate;
      });
    } catch (e) {
      print('Error fetching rate: $e');
    }
  }

  DropdownButton<String> getAndroidDropDownButton(){
    List<DropdownMenuItem<String>> dropdownItems = [];
    for(String currency in currencyList){
      dropdownItems.add(
        DropdownMenuItem(
          value: currency,
          child: Text(currency),
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) async {
        setState(() {
          selectedCurrency = value;
        });
        await updateExchangeRate();
      },
    );
  }

  CupertinoPicker getIOSCupertinoPicker(){
    List<Text> pickerItems = [];
    for(String currency in currencyList){
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (index) async {
        final selected = currencyList[index];
        setState(() {
          selectedCurrency = selected;
        });
        await updateExchangeRate();
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    updateExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convertidor CriptoMoneda"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                child: Text(
                  '1 BTC = ${rate == null ? '?' : rate!.toStringAsFixed(2)} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),

          Container(
            height: 150,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSCupertinoPicker() : getAndroidDropDownButton(),
          ),
        ],
      ),
    );
  }
}
