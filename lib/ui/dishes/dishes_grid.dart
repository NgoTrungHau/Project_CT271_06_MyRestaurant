import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/dish.dart';
import 'dish_grid_tile.dart';
import 'dishes_manager.dart';

class DishesGrid extends StatelessWidget {
  final bool showFavorites;

  const DishesGrid(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final dishes = context.select<DishesManager, List<Dish>>(
        (dishesManager) => showFavorites
            ? dishesManager.favoriteItems
            : dishesManager.items);
    return GridView.builder(
      padding: const EdgeInsets.all(15.0),
      itemCount: dishes.length,
      itemBuilder: (ctx, i) => DishGridTile(dishes[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 14 / 21,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
      ),
    );
  }
}
