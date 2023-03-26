import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fruits/provider/userProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../model/fruit.dart';

class CartProvider extends ChangeNotifier{
  late final UserProvider userProvider;
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

  Future<void> commande() async {
    final user = UserProvider();

    if (user.isLogin == false) {
      print('Vous devez vous connecter');
      return;
    }
    final id = user.idUser;
    final access_token = user.access_token;


    print('id: $id');
    print('access_token: $access_token');

    try {
      final response = await http.post(
        Uri.parse('https://fruits.shrp.dev/items/orders?access_token=$access_token'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $access_token',
        },
        body: jsonEncode({
          'customer_id': id,
          'amount': totalPanier,
          'fruits': panier,
        }),
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 201) {
        print('commande envoyée');
        clearPanier();
      } else {
        throw Exception('Erreur de chargement API');
      }
    } catch (e) {
      print(e);
    }
  }

}