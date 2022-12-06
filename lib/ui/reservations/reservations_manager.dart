import 'package:flutter/material.dart';

import '../../models/auth_token.dart';
import '../../models/dish.dart';
import '../../models/reservation.dart';
import '../../models/table.dart';
import '../../models/table_item.dart';
import '../../services/tables_service.dart';

class ReservationsManager with ChangeNotifier {
  List<TableB> _tables = [];
  Map<String, TableItem> _items = {};
  final List<ReservationItem> _reservations = [];
// Table
  final TablesService _tablesService;

  ReservationsManager([AuthToken? authToken])
      : _tablesService = TablesService(authToken);

  set authToken(AuthToken? authToken) {
    _tablesService.authToken = authToken;
  }

  Future<void> fetchTables([bool filterByUser = false]) async {
    _tables = await _tablesService.fetchTables(filterByUser);
    notifyListeners();
  }

  Future<void> addTable(TableB table) async {
    final newTable = await _tablesService.addTable(table);
    if (newTable != null) {
      _tables.add(newTable);
      notifyListeners();
    }
  }

  Future<void> updateTable(TableB table) async {
    final index = _tables.indexWhere((item) => item.id == table.id);
    if (index >= 0) {
      if (await _tablesService.updateTable(table)) {
        _tables[index] = table;
        notifyListeners();
      }
    }
  }

  Future<void> deleteTable(String id) async {
    final index = _tables.indexWhere((item) => item.id == id);
    TableB? existingDish = _tables[index];
    _tables.removeAt(index);
    notifyListeners();

    if (!await _tablesService.deleteTable(id)) {
      _tables.insert(index, existingDish);
      notifyListeners();
    }
  }

  int get tableCount {
    return _tables.length;
  }

  List<TableB> get tables {
    return [..._tables];
  }

  TableB findById(String id) {
    return _tables.firstWhere((tab) => tab.id == id);
  }

// tableItem
  int get dishCount {
    return _items.length;
  }

  List<TableItem> get dishes {
    return _items.values.toList();
  }

  Iterable<MapEntry<String, TableItem>> get dishEntries {
    return {..._items}.entries;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, tableItem) {
      total += tableItem.price * tableItem.quantity;
    });
    return total;
  }

  double totalAmountItem(String dishId) {
    var total = 0.0;
    _items.forEach((key, tableItem) {
      if (key == dishId) {
        total += tableItem.price * tableItem.quantity;
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
          () => TableItem(
                id: 'c${DateTime.now().toIso8601String()}',
                title: dish.title,
                price: dish.price,
                quantity: i,
                imageUrl: dish.imageURL,
              ));
    }
    notifyListeners();
  }

  void plusQuantity(String dishId, TableItem tableItem) {
    _items.update(
      dishId,
      (existingTableItem) => existingTableItem.copyWith(
        quantity: existingTableItem.quantity + 1,
      ),
    );
    notifyListeners();
  }

  void minusQuantity(
      BuildContext context, String dishId, TableItem tableItem) {
    _items.forEach((key, tableItem) {
      if (key == dishId) {
        if (tableItem.quantity > 1) {
          _items.update(
            dishId,
            (existingTableItem) => existingTableItem.copyWith(
              quantity: existingTableItem.quantity - 1,
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Are you sure?'),
              content:
                  const Text('Do you want to remove this dish from the table?'),
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
          (existingTableItem) => existingTableItem.copyWith(
                quantity: existingTableItem.quantity - 1,
              ));
    } else {
      _items.remove(dishId);
    }
    notifyListeners();
  }

  TableItem? getTableItem(String dishId) {
    return _items[dishId];
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

// reservations
  int get reservationCount {
    return _reservations.length;
  }

  List<ReservationItem> get reservations {
    return [..._reservations];
  }

  void addReservation(
      List<TableItem> tableDishes, double total, String title) async {
    _reservations.insert(
        0,
        ReservationItem(
          id: 'o${DateTime.now().toIso8601String()}',
          amount: total,
          dishes: tableDishes,
          dateTime: DateTime.now(),
          tableTitle: title,
        ));
    notifyListeners();
  }
}
