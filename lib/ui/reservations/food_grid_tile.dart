import 'package:flutter/material.dart';

import '../../models/dish.dart';

import '../dishes/dishes_detail_screen.dart';


class FoodListTile extends StatefulWidget {

  const FoodListTile(
    this.dish, {
      super.key, 
    }
  );


  final Dish dish;

  @override
  State<FoodListTile> createState() => _FoodListTileState();
}

class _FoodListTileState extends State<FoodListTile> {
  Dish? dish ;


  @override
  void initState() {
    super.initState();
    dish = widget.dish;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              DishDetailScreen.routeName,
              arguments: dish?.id,
            );
          },
          child: Image.network(
            dish!.imageURL,
            fit: BoxFit.cover,
          )
        )
      )
    );
  }
}