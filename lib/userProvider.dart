

import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier{

  String _email = '';
  String get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }



  String _token = '';
  String get token => _token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  String _id = '';
  String get id => _id;

  void setId(String id) {
    _id = id;
    notifyListeners();
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  void setIsLogin(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }



}