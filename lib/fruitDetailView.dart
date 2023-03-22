import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Fruit.dart';
import 'cartProvider.dart';

class FruitDetailView extends StatelessWidget {
  const FruitDetailView({super.key, required this.fruit});

  final Fruit fruit;


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
            Consumer(
                builder: (context, CartProvider cartProvider, child) {
                  return ElevatedButton(
                    onPressed: () {
                      cartProvider.addPanier(fruit);
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
                  );
                }),

          ],
        ),
      ),
    );
  }
}