import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/dish.dart';
import 'book_dishes_detail_screen.dart';
import 'reservations_manager.dart';

class BookDishesGridTile extends StatefulWidget {
  const BookDishesGridTile(
    this.dish, {
    super.key,
  });

  final Dish dish;

  @override
  State<BookDishesGridTile> createState() => _BookDishesGridTileState();
}

class _BookDishesGridTileState extends State<BookDishesGridTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
            footer: buildGridFooterBar(context),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    BookDishDetailScreen.routeName,
                    arguments: widget.dish.id,
                  );
                },
                child: Image.network(
                  widget.dish.imageURL,
                  fit: BoxFit.cover,
                ))));
  }

  Widget buildGridFooterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
              color: Colors.black.withOpacity(0.5),
              height: 35,
      child: GridTileBar(
        title: Text(widget.dish.title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text('\$${widget.dish.price}',
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color.fromARGB(255, 207, 207, 207),
            )),
        trailing: IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
          ),
          onPressed: () {
            final cart = context.read<ReservationsManager>();
            cart.addItem(widget.dish, 1);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: const Text('Dish added to table'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(widget.dish.id!);
                    },
                  )));
          },
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
