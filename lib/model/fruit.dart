import 'package:flutter/material.dart';
import 'package:fruits/model/country.dart';

class Fruit {

  Fruit({required this.id,required this.name, required this.price, required this.color, required this.image, required this.quantity, required this.origin, required this.season});
  final int id;
  final String name;
  final double price;
  final Color color;
  final String image;
  final int quantity;
  final Country origin;
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
      origin: Country.fromJson(json['origin']),
      season: json['season'],

    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'price': price,
        //convertir la couleur en string
        'color': color.toString(),
        'image': image,
        'quantity': quantity,
        'origin': origin.toJson(),
        'season': season,
      };

}