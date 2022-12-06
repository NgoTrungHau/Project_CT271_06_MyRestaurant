import 'package:flutter/material.dart';
import '../../models/dish.dart';
import 'package:provider/provider.dart';
import 'edit_dish_screen.dart';
import 'dishes_manager.dart';

class UserDishListTile extends StatelessWidget {
  final Dish dish;
  const UserDishListTile(
    this.dish, {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(dish.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(dish.imageURL),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            buildEditButton(context),
            buildDeleteButton(context),
          ],
        ),
      ),
    );
  }
  Widget buildEditButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        Navigator.of(context).pushNamed(
          EditDishScreen.routeName,
          arguments: dish.id,
        );
      },
      color: Theme.of(context).primaryColor,
    );
  }
  Widget buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        context.read<DishesManager>().deleteDish(dish.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Dish deleted',
                textAlign: TextAlign.center,
              )
            )
          );
      },
      color: Theme.of(context).errorColor,
    );
  }
}