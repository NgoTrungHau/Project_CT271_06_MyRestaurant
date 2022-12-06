import 'package:flutter/foundation.dart';

import '../../models/dish.dart';
import '../../models/auth_token.dart';
import '../../services/dishes_service.dart';

class DishesManager with ChangeNotifier {
    List<Dish> _items = [];

    final DishesService _dishesService;

    DishesManager([AuthToken? authToken])
        : _dishesService = DishesService(authToken);

    set authToken(AuthToken? authToken) {
      _dishesService.authToken = authToken;
    }

    Future<void> fetchDishes([bool filterByUser =false]) async {
      _items = await _dishesService.fetchDishes(filterByUser);
      notifyListeners();
    }

    Future<void> addDish(Dish dish) async {
      final newDish = await _dishesService.addDish(dish);
      if (newDish != null) {
        _items.add(newDish);
        notifyListeners();
      }
    }

    Future<void> updateDish(Dish dish) async {
      final index = _items.indexWhere((item) => item.id == dish.id);
      if (index >= 0) {
        if (await _dishesService.updateDish(dish)) {
          _items[index] = dish;
          notifyListeners();
        }
      }
    }

    Future<void> deleteDish(String id) async {
      final index = _items.indexWhere((item) => item.id == id);
      Dish? existingDish = _items[index];
      _items.removeAt(index);
      notifyListeners();

      if (!await _dishesService.deleteDish(id)) {
        _items.insert(index, existingDish);
        notifyListeners();
      }
    }

    Future<void> toggleFavoriteStatus(Dish dish) async {
      final savedStatus = dish.isFavorite;
      dish.isFavorite = !savedStatus;

      if(!await _dishesService.saveFavoriteStatus(dish)) {
        dish.isFavorite = savedStatus;
      }
    }

    int get itemCount {
      return _items.length;
    }

    List<Dish> get items {
      return [..._items];
    }

    List<Dish> get favoriteItems {
      return _items.where((proItem) => proItem.isFavorite).toList();
    }

    Dish findById(String id) {
      return _items.firstWhere((pro) => pro.id == id);
    }

}