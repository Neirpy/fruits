//lien api fruit : https://fruits.shrp.dev/items/fruits
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}




class Fruit {
  const Fruit({required this.id,required this.name, required this.price, required this.color, required this.image, required this.quantity, required this.origin, required this.season});
  final int id;
  final String name;
  final double price;
  final Color color;
  final String image;
  final int quantity;
  final int origin;
  final String season;

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      //convertir le string en double
      price: double.parse(json['price'].toString()),
      //convertir le string en couleur
      color: Color(int.parse(json['color'].substring(1, 7), radix: 16) + 0xFF000000),
      image: json['image'],
      quantity: int.parse(json['stock'].toString()),
      origin: int.parse(json['origin'].toString()),
      season: json['season'],

    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'price': price,
        'color': color,
        'image': image,
        'quantity': quantity,
        'origin': origin,
        'season': season,
      };

}


//faire une liste de fruits

/*List<Fruit> fruits = [
  const Fruit(name: 'Banane', price: 1.55, color: Colors.yellow, image: 'banane.png'),
  const Fruit(name: 'Pomme', price: 1.25, color: Colors.red , image: 'pomme.png'),
  const Fruit(name: 'Poire', price: 1.35, color: Colors.green, image: 'poire.png'),
];*/

/*List<Fruit> inventaireFruits = [
  const Fruit(name: 'Orange', price: 1.45, color: Colors.orange, image: 'orange.png'),
  const Fruit(name: 'Fraise', price: 1.65, color: Colors.pink, image: 'fraise.png'),
  const Fruit(name: 'Kiwi', price: 1.55, color: Colors.brown, image: 'kiwi.png'),
  const Fruit(name: 'Pêche', price: 1.25, color: Colors.purple, image: 'peche.png'),
  const Fruit(name: 'Mangue', price: 1.35, color: Colors.orange, image: 'mangue.png'),
  const Fruit(name: 'Ananas', price: 1.45, color: Colors.yellow, image: 'ananas.png'),
  const Fruit(name: 'Framboise', price: 1.65, color: Colors.red, image: 'framboise.png'),
  const Fruit(name: 'Goyave', price: 1.65, color: Colors.pink, image: 'goyave.png'),
];*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const FruitMasterScreen(
        title: 'Panier de fruits',
      ),
    );
  }
}

class FruitMasterScreen extends StatefulWidget {
  const FruitMasterScreen({super.key, required this.title});

  final String title;

  @override
  State<FruitMasterScreen> createState() => _FruitMasterState();

}

class _FruitMasterState extends State<FruitMasterScreen> {

  late List<Fruit> fruits;

  final List<Fruit> panier = [];



  Future<List<Fruit>> getFruits() async {
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

  void addPanier(Fruit fruit) {
    setState(() {
      panier.add(fruit);
    });
  }

  void removePanier(Fruit fruit) {
    setState(() {
      panier.remove(fruit);
    });
  }

  double _totalPanier(){
    double total = 0;
    for (var fruit in panier) {
      total += fruit.price;
    }
    return total;
  }

  //ajouter un fruit
  void addFruit() {
    // if(inventaireFruits.isEmpty){
    //   return;
    // }
    // setState(() {
    //   fruits.add(inventaireFruits[0]);
    //   inventaireFruits.removeAt(0);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    return PageView(
      controller: pageController,
      scrollDirection: Axis.vertical,
      children: [
        FutureBuilder(
            future: getFruits(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('${widget.title} : ${_totalPanier()} €',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        backgroundColor: Colors.red,
                        letterSpacing: 2.0,
                        wordSpacing: 2.0,
                        height: 2.0,
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

                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return FruitPreview(fruit: snapshot.data![index], addPanier: addPanier);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  floatingActionButton: FloatingActionButton(
                    onPressed: addFruit,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),

                  bottomNavigationBar: BottomAppBar(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.home),
                          color: Colors.blue,
                          onPressed: () {
                            pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          color: Colors.grey,
                          onPressed: () {
                            pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                          },
                        ),
                      ],
                    ),
                  ),
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

        CartScreen(panier: panier, pageController: pageController,addPanier: addPanier, removePanier: removePanier),
      ],
    );
  }
}

class FruitPreview extends StatelessWidget {
  const FruitPreview({super.key, required this.fruit, required this.addPanier});

  final Fruit fruit;

  final void Function(Fruit) addPanier;

  void addFruit() {
    addPanier(fruit);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Image(image: AssetImage('./images/${fruit.image}'),
                  width: 50,
                  height: 50,
                ),
                Text(fruit.name),
                Text(
                    '${fruit.price} €',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                    )
                ),
              ],
            ),
            trailing:Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                IconButton(onPressed: ()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FruitDetailView(fruit: fruit, addPanier: addPanier),settings: const RouteSettings(name: 'fruitDetail'), fullscreenDialog: true),
                  )
                }, icon: const Icon(Icons.search)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addFruit,
                ),
              ],
            ),

            tileColor: fruit.color,
          ),

        ],
      ),
    );
  }

}

//TP02

class FruitDetailView extends StatelessWidget {
  const FruitDetailView({super.key, required this.fruit, required this.addPanier});

  final Fruit fruit;

  final void Function(Fruit) addPanier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fruit.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: 700,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: fruit.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image(image: AssetImage('./images/${fruit.image}'),
                                width: 100,
                                height: 100,
                              ),

                              Text(
                                fruit.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                  '${fruit.price} €',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                  )
                              ),
                              Text(
                                  'Stock : ${fruit.quantity}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Roboto',
                                  ),
                              ),
                              Text(
                                  'Saison : ${fruit.season}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Roboto',
                                  ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    tileColor: fruit.color,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addPanier(fruit);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text(
                        '${fruit.name} ajouté au panier',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Roboto'
                        )
                    ),
                    backgroundColor: Colors.greenAccent,
                  ),
                );
              },
              child: const Text('Ajouter au panier'),
            ),

          ],
        ),
      ),
    );
  }
}

//TP03
class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required  this.panier, required this.pageController, required this.addPanier, required  this.removePanier});

  final List<Fruit> panier;
  final PageController pageController;
  final void Function(Fruit) addPanier;
  final void Function(Fruit) removePanier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: panier.length,
                itemBuilder: (context, index) {
                  return CartPreview(fruit: panier[index], addPanier: addPanier, removePanier: removePanier,);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.grey,
              onPressed: () {
                pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Colors.blue,
              onPressed: () {
                pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CartPreview extends StatelessWidget {
  const CartPreview({super.key, required this.fruit, required this.addPanier, required this.removePanier});

  final Fruit fruit;

  final void Function(Fruit) addPanier;
  final void Function(Fruit) removePanier;

  void addFruit() {
    addPanier(fruit);
  }

  void removeFruit() {
    removePanier(fruit);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Image(image: AssetImage('./images/${fruit.image}'),
                  width: 50,
                  height: 50,
                ),
                Text(fruit.name),
                Text(
                    '${fruit.price} €',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                    )
                ),
              ],
            ),
            trailing:Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                IconButton(onPressed: ()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FruitDetailView(fruit: fruit, addPanier: addPanier),settings: const RouteSettings(name: 'fruitDetail'), fullscreenDialog: true),
                  )
                }, icon: const Icon(Icons.search)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: removeFruit,
                ),
              ],
            ),

            tileColor: fruit.color,
          ),

        ],
      ),
    );
  }

}
