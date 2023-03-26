import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fruits/model/user.dart';
import 'package:fruits/provider/userProvider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onLogin});

  final Function onLogin;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login(String email, String password) async {
    try{
      final response = await http.post(
        Uri.parse('https://fruits.shrp.dev/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        print(response.body);
        var decoded = jsonDecode(response.body);
        var data= Jwt.parseJwt(decoded['data']['access_token']);
        User(
          id: data['id'],
          email: data['email'],
          password: password,
          access_token: decoded['data']['access_token'],
          renew_token: decoded['data']['renew_token'],
        );
      }

    } catch (e) {
      print(e);
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Consumer(builder: (context, UserProvider userProvider, child
    ) =>
        userProvider.isLogin ?  const LoginScreen() : Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.pink[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<UserProvider>(context, listen: false).register(_emailController.text, _passwordController.text);
                        if (_formKey.currentState!.validate()) {
                          _emailController.clear();
                          _passwordController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content:
                              Text('Utilisateur créé'),
                              backgroundColor: Colors.greenAccent,
                            ),
                          );
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        login(_emailController.text, _passwordController.text);
                        if (_formKey.currentState!.validate()) {
                          userProvider.setIsLogin(true);
                          userProvider.setEmail(_emailController.text);

                          _emailController.clear();
                          _passwordController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content:
                              Text('Utilisateur connecté'),
                              backgroundColor: Colors.greenAccent,
                            ),
                          );

                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer(builder: (context, UserProvider userProvider, child) {
            return Text(userProvider.emailUser);
          }),
          Consumer(builder: (context, UserProvider userProvider, child) {
            return ElevatedButton(
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).logout();
                userProvider.setIsLogin(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content:
                    Text('Utilisateur déconnecté'),
                    backgroundColor: Colors.grey,
                  ),
                );

              },
              child: const Text('Logout'),
            );
          }),
        ],
      ),
    );
  }
}