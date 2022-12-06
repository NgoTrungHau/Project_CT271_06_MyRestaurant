import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/dish.dart';
import '../dishes/dishes_manager.dart';
import 'reservations_manager.dart';

class BookDishDetailScreen extends StatefulWidget {
  static const routeName = '/book-dish-detail';
  const BookDishDetailScreen(
      this.dish,
    {
      super.key, 
    }
  );

  final Dish dish;

  @override
  State<BookDishDetailScreen> createState() => _BookDishDetailScreenState();
}

class _BookDishDetailScreenState extends State<BookDishDetailScreen> {
  Dish? dish;

  int i = 1;

  @override
  void initState() {
    super.initState();
    dish = widget.dish;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<ReservationsManager>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dish.title),
        actions: [
          buildFavoriteButton(context, dish!)
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height:300,
              width: double.infinity,
              child: Image.network(
                widget.dish.imageURL,
                fit: BoxFit.cover,
              )
            ),
            const SizedBox(height: 10,),
            Text(
              '\$${widget.dish.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height:10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                widget.dish.description,
                textAlign: TextAlign.center,
                softWrap: true,
              )
            ),
            const SizedBox(
              height:70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.remove, size:40),
                  onPressed: (() {
                    if(i>1) {
                      setState(() {
                        i--;
                      });
                      print(i);
                    }
                  }),
                ),
                const SizedBox(
                  width:30,
                ),
                SizedBox(
                  width: 60.0,
                  height: 30.0,
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                      controller: TextEditingController()
                        ..text = '${i}',
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
                    )
                  ),
                ),
                const SizedBox(
                  width:30,
                ),
                IconButton(
                  color: Colors.blue,
                  icon: const Icon(Icons.add, size:40),
                  onPressed: (() {
                    if(i<99) {
                      setState(() {
                        i++;
                      });
                      print(i);
                    }
                  }),
                )
              ]
            ),
            const SizedBox(
              height:20,
            ),
            TextButton(
              child: Chip(
                label: const Text(
                  'Add to table',
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                cart.addItem(dish!,i);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: const Text('Dish added to cart'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed:() {
                          cart.removeSingleItem(dish!.id!);
                        },
                      )
                    )
                   );
                i=1;
              },
            ),
            
          ]
        )
      )
    );
  }
  Widget buildFavoriteButton(BuildContext context, Dish dish) {
  return ValueListenableBuilder<bool>(
      valueListenable: dish.isFavoriteListenable,
      builder: (ctx, isFavorite, child) {
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
          ),
          color: Colors.black,
          onPressed: () {
            ctx.read<DishesManager>().toggleFavoriteStatus(dish);
          },
        );
      });
}
}