import 'package:flutter/material.dart';
import 'package:fruits/model/user.dart';

class User{
  User({required this.id, required this.email, required this.password, required this.access_token, required this.renew_token});
  final String id;
  final String email ;
  final String password;
  final String access_token;
  final String renew_token;

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