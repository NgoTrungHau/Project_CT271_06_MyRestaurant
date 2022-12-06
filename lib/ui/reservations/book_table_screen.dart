import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/dish.dart';
import '../../models/table.dart';
import '../dishes/dishes_manager.dart';
import 'book_dishes_grid.dart';
import 'reservations_manager.dart';
import 'table_item_card.dart';

class BookScreen extends StatefulWidget {
  static const routeName = '/book-table';

  const BookScreen(
    this.table, {
    super.key,
  });

  final TableB table;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  TableB? table;

  int i = 1;

  @override
  void initState() {
    super.initState();
    table = widget.table;
  }

  @override
  Widget build(BuildContext context) {
    final table = context.watch<ReservationsManager>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.table.title,
            style: const TextStyle(color: Colors.white)
          ),
          actions: <Widget>[
            buildDeleteAllButton(table),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 237, 205),
        body: Column(children: <Widget>[
          buildCartSummary(table, context),
          const SizedBox(height: 10),
          Expanded(
            child: buildTableDetails(table),
          ),
          const Text('Choose dish',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Expanded(
            child: buildChooseDetails(table),
          )
        ]));
  }

  Widget buildTableDetails(ReservationsManager table) {
    return ListView(
      children: table.dishEntries
          .map(
            (entry) => TableItemCard(
              dishId: entry.key,
              tableItem: entry.value,
            ),
          )
          .toList(),
    );
  }

  Widget buildChooseDetails(ReservationsManager table) {
    final dishes = context.select<DishesManager, List<Dish>>(
        (dishesManager) => dishesManager.items);

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: dishes.length,
      itemBuilder: (ctx, i) => BookDishesGridTile(dishes[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 6 / 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }

  Widget buildCartSummary(ReservationsManager table, BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight:Radius.circular(20),
            topLeft:Radius.circular(20)
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Chip(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        label: Text(
                          '\$${table.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(6.0),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: table.totalAmount <= 0
                        ? null
                        : () {
                            context.read<ReservationsManager>().addReservation(
                                  table.dishes,
                                  table.totalAmount,
                                  widget.table.title,
                                );
                            table.clear();
                          },
                    style: TextButton.styleFrom(
                      textStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    child: const Text('BOOK NOW',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ])));
  }

  Widget buildDeleteAllButton(ReservationsManager table) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        table.clear();
      },
    );
  }
}
