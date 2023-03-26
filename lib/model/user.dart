import 'package:flutter/material.dart';
import 'package:fruits/model/user.dart';

class User{
  User({required this.id, required this.email, required this.password, required this.access_token, required this.renew_token});
  String id;
  String email ;
  String password;
  String access_token;
  String renew_token;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      access_token: json['access_token'],
      renew_token: json['renew_token'],
    );
  }
}