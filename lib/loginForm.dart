import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fruits/userProvider.dart';
import 'package:http/http.dart' as http;
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
  String _id = '';
  String token = '';
  String email = '';
  String password = '';

  Future<void> signIn(String email, String password) async {
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
        //decode avec jwt_decode le access token du body
        var decoded = jsonDecode(response.body);
        var data= Jwt.parseJwt(decoded['data']['access_token']);
        setState(() {
          _id = data['id'];
          token = decoded['data']['access_token'];
        });
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
        'email': email,
        'password': password,
      }),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return userProvider.isLogin ? const LoginScreen() : Form(
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
                      signIn(_emailController.text, _passwordController.text);
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
                        Provider.of<UserProvider>(context, listen: false).setId(_id);
                        Provider.of<UserProvider>(context, listen: false).setToken(token);
                        Provider.of<UserProvider>(context, listen: false).setEmail(_emailController.text);
                        Provider.of<UserProvider>(context, listen: false).setIsLogin(true);
                        email = _emailController.text;
                        password = _passwordController.text;
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
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userEmail = userProvider.email;
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
          Text(userEmail),
          ElevatedButton(
            onPressed: () {
              userProvider.setId('');
              userProvider.setToken('');
              userProvider.setEmail('');
              userProvider.setIsLogin(false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content:
                  Text('Utilisateur déconnecté'),
                  backgroundColor: Colors.grey,
                ),
              );

            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}