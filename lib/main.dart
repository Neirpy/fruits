//lien api fruit : https://fruits.shrp.dev/items/fruits

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fruits/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'provider/cartProvider.dart';
import 'model/fruit.dart';
import 'screen/fruitMasterScreen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  MyApp({super.key});

  late List<Fruit> fruits;

  Future<List<Fruit>> fetchApi () async {
    final response = await http.get(Uri.parse('https://fruits.shrp.dev/items/fruits?fields=*.*'));

    if(response.statusCode == 200 || response.statusCode == 304){
      final fruitList = jsonDecode(response.body);
      var ft = fruitList['data'].map<Fruit>((fruit) => Fruit.fromJson(fruit));

      fruits=ft.toList();

    }
    else{
      throw Exception('Erreur de chargement API');
    }

    return fruits;

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home:
      FutureBuilder(
        future: fetchApi(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FruitMasterScreen(
              title: 'Panier de fruits',
              fruits: fruits,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },

      )
      // const FruitMasterScreen(
      //   title: 'Panier de fruits',
      // ),
    );
  }
}



