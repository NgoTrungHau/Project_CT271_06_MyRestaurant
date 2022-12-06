import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/dish.dart';
import '../cart/cart_manager.dart';
import 'dishes_manager.dart';

class DishDetailScreen extends StatefulWidget {
  static const routeName = '/dish-detail';
  const DishDetailScreen(
    this.dish, {
    super.key,
  });

  final Dish dish;

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  Dish? dish;

  int i = 1;

  @override
  void initState() {
    super.initState();
    dish = widget.dish;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartManager>();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.dish.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          actions: [
            buildFavoriteButton(context, dish!),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                widget.dish.imageURL,
                fit: BoxFit.cover,
              )),
          const SizedBox(
            height: 10,
          ),
          Text(
            '\$${widget.dish.price}',
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                widget.dish.description,
                textAlign: TextAlign.center,
                softWrap: true,
              )),
          const SizedBox(
            height: 70,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            IconButton(
              color: Colors.orangeAccent,
              icon: const Icon(Icons.remove, size: 40),
              onPressed: (() {
                if (i > 1) {
                  setState(() {
                    i--;
                  });
                  print(i);
                }
              }),
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              width: 60.0,
              height: 30.0,
              child: Center(
                  child: TextField(
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                controller: TextEditingController()..text = '${i}',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {
                    final number = int.parse(value);
                    i = number;
                  });
                },
              )),
            ),
            const SizedBox(
              width: 30,
            ),
            IconButton(
              color: Colors.orangeAccent,
              icon: const Icon(Icons.add, size: 40),
              onPressed: (() {
                if (i < 99) {
                  setState(() {
                    i++;
                  });
                  print(i);
                }
              }),
            )
          ]),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            child: Chip(
              label: const Text('Add to cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
              cart.addItem(dish!, i);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: const Text('Dish added to cart'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(dish!.id!);
                      },
                    )));
              i = 1;
            },
          ),
        ])));
  }

  Widget buildFavoriteButton(BuildContext context, Dish dish) {
    return ValueListenableBuilder<bool>(
        valueListenable: dish.isFavoriteListenable,
        builder: (ctx, isFavorite, child) {
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: const Color.fromARGB(255, 230, 0, 81),
            onPressed: () {
              ctx.read<DishesManager>().toggleFavoriteStatus(dish);
            },
          );
        });
  }
}
