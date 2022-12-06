import 'package:flutter/material.dart';

import '../../models/cart_item.dart';
import '../../models/dish.dart';

class CartManager with ChangeNotifier {
  Map<String, CartItem> _items = {};

  int get dishCount {
    return _items.length;
  }

  List<CartItem> get dishes {
    return _items.values.toList();
  }

  Iterable<MapEntry<String, CartItem>> get dishEntries {
    return {..._items}.entries;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  double totalAmountItem(String dishId) {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      if (key == dishId) {
        total += cartItem.price * cartItem.quantity;
      }
    });
    return total;
  }

  void addItem(Dish dish, int i) {
    if (_items.containsKey(dish.id)) {
      _items.update(
        dish.id!,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + i,
        ),
      );
    } else {
      _items.putIfAbsent(
          dish.id!,
          () => CartItem(
                id: 'c${DateTime.now().toIso8601String()}',
                title: dish.title,
                price: dish.price,
                quantity: i,
                imageUrl: dish.imageURL,
              ));
    }
    notifyListeners();
  }

  void plusQuantity(String dishId, CartItem cartItem) {
    _items.update(
      dishId,
      (existingCartItem) => existingCartItem.copyWith(
        quantity: existingCartItem.quantity + 1,
      ),
    );
    notifyListeners();
  }

  void minusQuantity(
      BuildContext context, String dishId, CartItem cartItem) {
    _items.forEach((key, cartItem) {
      if (key == dishId) {
        if (cartItem.quantity > 1) {
          _items.update(
            dishId,
            (existingCartItem) => existingCartItem.copyWith(
              quantity: existingCartItem.quantity - 1,
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Are you sure?'),
              content:
                  const Text('Do you want to remove the item from the cart?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                    removeItem(dishId);
                  },
                ),
              ],
            ),
          );
        }
      }
    });
    notifyListeners();
  }

  void removeItem(String dishId) {
    _items.remove(dishId);
    notifyListeners();
  }

  void removeSingleItem(String dishId) {
    if (!_items.containsKey(dishId)) {
      return;
    }
    if (_items[dishId]?.quantity as num > 1) {
      _items.update(
          dishId,
          (existingCartItem) => existingCartItem.copyWith(
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(dishId);
    }
    notifyListeners();
  }

  CartItem? getCartItem(String dishId) {
    return _items[dishId];
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
