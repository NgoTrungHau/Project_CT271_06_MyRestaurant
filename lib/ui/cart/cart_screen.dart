import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../orders/orders_manager.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';

StreamController<int> streamController = StreamController<int>();

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Colors.white)
        ),
        actions: [
          buildDeleteAllButton(cart)
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 237, 205),
      body: Column(
        children: <Widget>[
          buildCartSummary(cart, context),
          const SizedBox(height: 10),
          Expanded(
            child: buildCartDetails(cart),
          )
        ],
      ),
    );
  }

  Widget buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.dishEntries
          .map(
            (entry) => CartItemCard(
              dishId: entry.key,
              cartItem: entry.value,
            ),
          )
          .toList(),
    );
  }

  Widget buildCartSummary(CartManager cart, BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight:Radius.circular(20),
            topLeft:Radius.circular(20)
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      Chip(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        label: Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(6.0),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: cart.totalAmount <= 0
                        ? null
                        : () {
                            context.read<OrdersManager>().addOrder(
                                  cart.dishes,
                                  cart.totalAmount,
                                );
                            cart.clear();
                          },
                    style: TextButton.styleFrom(
                      textStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    child: const Text('ORDER NOW',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ])));
  }
  Widget buildDeleteAllButton(CartManager cart) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        cart.clear();
      },
    );
  }
}
