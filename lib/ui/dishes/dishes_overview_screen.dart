import 'package:flutter/material.dart';
import 'package:flutter_application_myrestaurant/ui/screen.dart';
import 'package:provider/provider.dart';
import 'dishes_grid.dart';
import '../shared/app_drawer.dart';
import 'top_right_badge.dart';

class DishesOverviewScreen extends StatefulWidget {
  const DishesOverviewScreen({super.key});

  @override
  State<DishesOverviewScreen> createState() => _DishesOverviewScreenState();
}

class _DishesOverviewScreenState extends State<DishesOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchDishes;

  @override
  void initState() {
    super.initState();
    _fetchDishes = context.read<DishesManager>().fetchDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyRestaurant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        ),
        actions: <Widget>[
          buildShoppingCartIcon(),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      backgroundColor: const Color.fromARGB(255, 255, 237, 205),
      body: Builder(
        builder: (BuildContext context){
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: buildIcons(),
              ),
              Expanded(
                flex: 8,
                child: FutureBuilder(
                future: _fetchDishes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ValueListenableBuilder<bool>(
                        valueListenable: _showOnlyFavorites,
                        builder: (context, onlyFavorites, child) {
                          return DishesGrid(onlyFavorites);
                        });
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              ),
              ),
            ]
          );
        }
      )
    );
  }

  Widget buildDishesGrid(BuildContext context) {
    return FutureBuilder(
        future: _fetchDishes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder<bool>(
                valueListenable: _showOnlyFavorites,
                builder: (context, onlyFavorites, child) {
                  return DishesGrid(onlyFavorites);
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );
  }

  Widget buildIcons() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    shadowColor: Colors.transparent.withOpacity(0.0),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    "All",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ), 
                  onPressed: () { 
                    _showOnlyFavorites.value = false;
                  }, 

                ),
            ),
            buildBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    shadowColor: Colors.transparent.withOpacity(0.0),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ), 
                  onPressed: () { 
                    if (_showOnlyFavorites.value == false) {
                    _showOnlyFavorites.value = true;
                  } else {
                    _showOnlyFavorites.value = false;
                  }
                  }, 

                ),
            ),
            buildBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    shadowColor: Colors.transparent.withOpacity(0.0),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Icon(
                    Icons.no_meals,
                    color: Colors.white,
                  ), 
                  onPressed: () {}, 
                ),
            ),
            buildBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    shadowColor: Colors.transparent.withOpacity(0.0),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Icon(
                    Icons.local_drink,
                    color: Colors.white,
                  ), 
                  onPressed: () {}, 
                ),
            ),
            buildBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    shadowColor: Colors.transparent.withOpacity(0.0),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Icon(
                    Icons.cake,
                    color: Colors.white,
                  ), 
                  onPressed: () {}, 
                ),
            ),
            buildBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    shadowColor: Colors.transparent.withOpacity(0.0),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Icon(
                    Icons.icecream,
                    color: Colors.white,
                  ), 
                  onPressed: () {}, 
                ),
            ), 
          ]
        )
      ]
    );
  }

  Widget buildBox({required Widget child}) => Container(
    height: 40.0,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Color.fromARGB(255, 255, 169, 154),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: child,
  );

  Widget buildShoppingCartIcon() {
    return Consumer<CartManager>(builder: (ctx, cartManager, child) {
      return TopRightBadge(
          data: cartManager.dishCount,
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: (() {
              Navigator.of(ctx).pushNamed(CartScreen.routeName);
            }),
          ));
    });
  }

}
