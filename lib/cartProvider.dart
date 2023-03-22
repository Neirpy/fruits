import 'package:flutter/material.dart';

import 'Fruit.dart';

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



  String nbFruitPanierMemo(Fruit fruit){
    var nbFruit=_panier.where((element) => element.id == fruit.id).length;
    notifyListeners();
    if(nbFruit==0){
      return '';
    }
    return 'x$nbFruit';
  }

}