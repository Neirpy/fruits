import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'Fruit.dart';
import 'cartProvider.dart';
import 'cartScreen.dart';
import 'fruitPreview.dart';

class FruitMasterScreen extends StatefulWidget {
  const FruitMasterScreen({super.key, required this.title});

  final String title;

  @override
  State<FruitMasterScreen> createState() => _FruitMasterState();

}



class _FruitMasterState extends State<FruitMasterScreen> {

  late List<Fruit> fruits;

  Future<List<Fruit>> fetchApi () async {
    final response = await http.get(Uri.parse('https://fruits.shrp.dev/items/fruits'));
    List<Fruit> fruits = [];


    if(response.statusCode == 200 || response.statusCode == 304){
      final fruitList = jsonDecode(response.body);
      var ft = fruitList['data'].map<Fruit>((fruit) => Fruit.fromJson(fruit));

      fruits = ft.toList();

    }
    else{
      throw Exception('Erreur de chargement API');
    }

    return fruits;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Consumer(builder: (context, CartProvider cartProvider, child) =>
                    Text('${widget.title} : ${cartProvider.totalPanier} €',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        fontFamily: 'Roboto',
                        backgroundColor: Colors.red,
                        letterSpacing: 2.0,
                        wordSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                    ),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                      const CartScreen()
                      ),
                    );
                  },
                ),
              ]
          ),
        ),

        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder(
                        future: fetchApi(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return FruitPreview(fruit: snapshot.data![index]);
                              },
                            );
                          }
                          else if (snapshot.hasError) {
                            return const Center(
                              child: Text('Erreur de chargement des fruits'),
                            );
                          }
                          else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    ),
                  ),
                ]
            )
        )
    );
  }
}