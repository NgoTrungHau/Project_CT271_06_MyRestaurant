import 'package:flutter/material.dart';
import 'edit_dish_screen.dart';
import 'user_dishes_list_tile.dart';
import 'dishes_manager.dart';
import '../shared/app_drawer.dart';
import 'package:provider/provider.dart';

class UserDishesScreen extends StatelessWidget {
  static const routeName = '/user-dishes';
  const UserDishesScreen({super.key});

  Future<void> _refreshDishes(BuildContext context) async {
    await context.read<DishesManager>().fetchDishes(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your dishes',
          style: TextStyle(color: Colors.white)
        ),
        actions: <Widget>[
          buildAddButton(context),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      backgroundColor: const Color.fromARGB(255, 255, 237, 205),
      body: FutureBuilder(
        future: _refreshDishes(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => print('refresh dishes'),
            child: buildUserDishListView(),
          );
        }
      )
    );
  }
  Widget buildUserDishListView() {
    return Consumer<DishesManager>(
      builder: (ctx, dishesManager, child) {
        return ListView.builder(
          itemCount: dishesManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserDishListTile(
                dishesManager.items[i],
              ),
              const Divider(),
            ],
          ),
        );
      }
    );
  }
  Widget buildAddButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditDishScreen.routeName,
        );
      },
    );
  }
}