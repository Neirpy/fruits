import 'package:flutter/material.dart';

import 'fruit.dart';

class CartProvider extends ChangeNotifier{
  final List<Fruit> _panier = [];
  List<Fruit> get panier => _panier;

  void addPanier(Fruit fruit) {
    _panier.add(fruit);
    notifyListeners();
  }


  void removePanier(Fruit fruit) {
    _panier.remove(fruit);
    notifyListeners();
  }

  void clearPanier() {
    _panier.clear();
    notifyListeners();
  }

  double _totalPanier(){
    double total = 0;
    for (var fruit in _panier) {
      total += fruit.price;
    }
    return double.parse(total.toStringAsFixed(2));
  }
  double get totalPanier => _totalPanier();



  int nbFruitPanierMemo(Fruit fruit){
    var nbFruit=_panier.where((element) => element.id == fruit.id).length;

    return nbFruit;
  }

  //sort fruit by season
  List<Fruit> sortFruitBySeason(String season, List<Fruit> fruits){
    List<Fruit> sortFruits = [];
    if(season != 'Tous') {
      for (var fruit in fruits) {
        if (fruit.season == season) {
          sortFruits.add(fruit);
        }
      }
    }
    return fruits;
  }
}