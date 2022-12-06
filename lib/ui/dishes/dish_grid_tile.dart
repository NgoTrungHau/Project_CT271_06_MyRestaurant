import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/dish.dart';
import '../shared/dialog_utils.dart';
import 'dishes_detail_screen.dart';
import 'dishes_manager.dart';

class DishGridTile extends StatelessWidget {
  const DishGridTile(
    this.dish, {
    super.key,
  });

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                offset: Offset(0, 10),
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          DishDetailScreen.routeName,
                          arguments: dish.id,
                        );
                      },
                      child: Image.network(
                        dish.imageURL,
                        width: 200,
                        height: 120,
                        fit: BoxFit.cover,
                      ))),
              const SizedBox(height: 10),
              Text(
                dish.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${dish.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 3),
              Row(children: <Widget>[
                ValueListenableBuilder<bool>(
                    valueListenable: dish.isFavoriteListenable,
                    builder: (ctx, isFavorite, child) {
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          ctx
                              .read<DishesManager>()
                              .toggleFavoriteStatus(dish);
                        },
                      );
                    }),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    showAddNumberDialog(context, dish);
                  },
                  color: Theme.of(context).colorScheme.secondary,
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridFooterBar(BuildContext context) {
    return GridTileBar(
        backgroundColor: Colors.black87.withOpacity(0.6),
        leading: ValueListenableBuilder<bool>(
            valueListenable: dish.isFavoriteListenable,
            builder: (ctx, isFavorite, child) {
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  ctx.read<DishesManager>().toggleFavoriteStatus(dish);
                },
              );
            }),
        title: Text(
          dish.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.shopping_cart,
          ),
          onPressed: () {
            showAddNumberDialog(context, dish);
          },
          color: Theme.of(context).colorScheme.secondary,
        ));
  }
}
