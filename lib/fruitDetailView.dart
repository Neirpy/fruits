import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fruits/quantityBadge.dart';
import 'package:provider/provider.dart';

import 'fruit.dart';
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
      body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.centerLeft,
                      color: fruit.color,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            image: AssetImage('./images/${fruit.image}'),
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fruit.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Text(
                                  '${fruit.price} €',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Text(
                                  'Stock : ${fruit.quantity}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Text(
                                  'Saison : ${fruit.season}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Text(
                                  'Origine : ${fruit.origin.name}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Consumer(builder: (context, CartProvider cartProvider, child) =>
                                   QuantityBadge(quantity: cartProvider.nbFruitPanierMemo(fruit))
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child:
                FlutterMap(
                  options: MapOptions(
                    center: fruit.origin.location,
                    zoom: 9.2,
                  ),
                  nonRotatedChildren: [
                    AttributionWidget.defaultWidget(
                      source: 'OpenStreetMap contributors',
                      onSourceTapped: null,
                    ),
                  ],
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 100.0,
                          height: 100.0,
                          point: fruit.origin.location,
                          builder: (ctx) =>
                              const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 30.0
                              ),
                        ),
                      ],
                    )
                  ],
                )
              ),
            Flexible(
              flex: 1,
              child: Consumer(
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
          ),
        ],
      ),
    );
  }
}