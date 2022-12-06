import 'cart_item.dart';

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> dishes;
  final DateTime dateTime;

  int get dishCount {
    return dishes.length;
  }

  OrderItem({
    this.id,
    required this.amount,
    required this.dishes,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith({
    String? id,
    double? amount,
    List<CartItem>? dishes,
    DateTime? dateTime,
  }) {
    return OrderItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      dishes: dishes ?? this.dishes,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}