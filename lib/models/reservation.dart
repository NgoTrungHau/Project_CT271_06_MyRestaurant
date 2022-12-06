import 'table_item.dart';

class ReservationItem {
  final String? id;
  final double amount;
  final List<TableItem> dishes;
  final String tableTitle;
  final DateTime dateTime;

  int get dishCount {
    return dishes.length;
  }

  ReservationItem({
    this.id,
    required this.amount,
    required this.dishes,
    required this.tableTitle,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  ReservationItem copyWith({
    String? id,
    double? amount,
    List<TableItem>? dishes,
    String? tableTitle,
    DateTime? dateTime,
  }) {
    return ReservationItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      dishes: dishes ?? this.dishes,
      tableTitle: tableTitle ?? this.tableTitle,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'dishes': dishes,
  //     'table': tableTitle,
  //     'amount': amount,
  //   };
  // }

  // static ReservationItem fromJson(Map<String, dynamic> json) {
  //   return ReservationItem(
  //     id: json['id'],
  //     amount: json['amount'],
  //     dishes: json['dishes'],
  //     tableTitle: json['table'],
  //     dateTime: json['dateTime'],
  //   );
  // }
}
