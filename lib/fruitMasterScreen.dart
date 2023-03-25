import 'package:flutter/material.dart';


import 'package:provider/provider.dart';


import 'fruit.dart';
import 'cartProvider.dart';
import 'cartScreen.dart';
import 'fruitPreview.dart';

class FruitMasterScreen extends StatefulWidget {
  const FruitMasterScreen({super.key, required this.title ,required this.fruits});

  final String title;

  final List<Fruit> fruits;


  @override
  State<FruitMasterScreen> createState() => _FruitMasterState();

}

class _FruitMasterState extends State<FruitMasterScreen> {

  late List<Fruit> fruits;
  late List<Fruit> allFruits;

  //sort fruit by season
  void sortFruitBySeason(String season)  {
    List<Fruit> sortFruits = widget.fruits;
    if (season != 'Tous') {
      sortFruits=sortFruits.where((fruit) => fruit.season == season).toList();
    }
    setState(() {
      fruits=sortFruits;
    });
  }

  @override
  void initState() {
    super.initState();
    fruits = widget.fruits;
    allFruits=widget.fruits;
  }
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
                  // barre avec un select pour trier les saisons
                  SizedBox(
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          width: 100,
                          color: Colors.blue,
                          child: Center(child: TextButton(
                            onPressed: () => {
                              sortFruitBySeason('Tous')
                            },
                            child: const Text(
                                'Tous',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                            )
                          )),
                        ),
                        Container(
                          width: 100,
                          color: Colors.red,
                          child: Center(child: TextButton(
                            onPressed: () => sortFruitBySeason('Printemps'),
                            child: const Text(
                                'Printemps',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                            )
                          )),
                        ),
                        Container(
                          width: 100,
                          color: Colors.yellow,
                          child: Center(child: TextButton(
                            onPressed: () => sortFruitBySeason('Eté'),
                            child: const Text(
                                'Eté',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                            )
                          )),
                        ),
                        Container(
                          width: 100,
                          color: Colors.orange,
                          child: Center(child: TextButton(
                            onPressed: () => sortFruitBySeason('Automne'),
                            child: const Text(
                                'Automne',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                            )
                          )),
                        ),
                        Container(
                          width: 100,
                          color: Colors.brown,
                          child: Center(child: TextButton(
                            onPressed: () => sortFruitBySeason('Hiver'),
                            child: const Text(
                                'Hiver',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                            )
                          )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child:
                      ListView.builder(
                              itemCount: fruits.length,
                              itemBuilder: (context, index) {
                                return FruitPreview(fruit: fruits[index]);
                          },
                      )
                    ),
                ]
            )
        )
    );
  }
}