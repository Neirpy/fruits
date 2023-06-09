import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../model/user.dart';


class UserProvider extends ChangeNotifier {
    final User _user = User(id: '', email: '', password: '', access_token: '', renew_token: '');
    User get user => _user;

    bool _isLogin = false;
    bool get isLogin => _isLogin;

    void setIsLogin(bool isLogin) {
      _isLogin = isLogin;
      notifyListeners();
    }

    String emailUser = '';
    String get getEmail => emailUser;

    void setEmail(String email) {
      emailUser = email;
      notifyListeners();
    }

    String idUser = '';
    String get getId => idUser;

    void setId(String id) {
      idUser = id;
      notifyListeners();
    }

    String access_token = '';
    String get getAccessToken => access_token;

    void setAccessToken(String token) {
      access_token = token;
      notifyListeners();
    }


    Future<void> register(String email, String password) async {
      try{
        final response = await http.post(
          Uri.parse('https://fruits.shrp.dev/users'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
            'role':'ca2c1507-d542-4f47-bb63-a9c44a536498'
          }),
        );
        print(response.body);
        if(response.statusCode == 204){
          print('user created');
        }
        else{
          throw Exception('Erreur de chargement API');
        }

      } catch (e) {
        print(e);
      }
    }


    Future<void> logout() async {
      final response = await http.post(
        Uri.parse('https://fruits.shrp.dev/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': user.email,
          'password': user.password,
        }),
      );
      if (response.statusCode == 200) {
        print('user logged out');
        notifyListeners();
      }
      else {
        throw Exception('Erreur de chargement API');
      }
    }
}
