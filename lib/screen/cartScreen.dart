//TP03

import 'package:flutter/material.dart';
import 'package:fruits/form/loginForm.dart';
import 'package:fruits/provider/userProvider.dart';
import 'package:provider/provider.dart';

import '../model/fruit.dart';
import '../provider/cartProvider.dart';
import '../view/fruitDetailView.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Panier'),
            Consumer(builder: (context, CartProvider cartProvider, child) {
              return Text(
                  '${cartProvider.panier.length} fruits',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'Roboto',
                  )
              );
            }),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: ()=>Provider.of<CartProvider>(context, listen: false).clearPanier(),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child:
              Consumer(builder: (context, CartProvider cartProvider, child) {
                return ListView.builder(
                  itemCount:cartProvider.panier.length,
                  itemBuilder: (context, index) {
                    return CartPreview(fruit: cartProvider.panier[index]);
                  },
                );
              }),
            ),
            Consumer2<UserProvider, CartProvider>(builder: (context,  UserProvider userProvider, CartProvider cartProvider, child) {
              return cartProvider.panier.isNotEmpty && userProvider.isLogin  ? ElevatedButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).commande(context);
                },
                child: const Text('Passer commande'),
              ) : Container();
            }),
            LoginForm(onLogin: (String username, String password) {

            },),
          ],
        ),
      ),
    );
  }
}

class CartPreview extends StatelessWidget {
  const CartPreview({super.key, required this.fruit});

  final Fruit fruit;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Image(image: AssetImage('./images/${fruit.image}'),
                  width: 50,
                  height: 50,
                ),
                Text(fruit.name),
                Text(
                    '${fruit.price} €',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                    )
                ),
              ],
            ),
            trailing:Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                IconButton(onPressed: ()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FruitDetailView(fruit: fruit),settings: const RouteSettings(name: 'fruitDetail'), fullscreenDialog: true),
                  )
                }, icon: const Icon(Icons.search)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: ()=>Provider.of<CartProvider>(context, listen: false).removePanier(fruit),

                ),

              ],
            ),

            tileColor: fruit.color,
          ),

        ],
      ),
    );
  }

}