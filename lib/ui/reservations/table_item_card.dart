import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/table_item.dart';
import '../shared/dialog_utils.dart';
import 'reservations_manager.dart';

class TableItemCard extends StatefulWidget {
  final String dishId;
  final TableItem tableItem;

  const TableItemCard({
    required this.dishId,
    required this.tableItem,
    super.key,
  });

  @override
  State<TableItemCard> createState() => _TableItemCardState();
}

class _TableItemCardState extends State<TableItemCard> {
  TableItem? tableItem;

  @override
  void initState() {
    super.initState();
    tableItem = widget.tableItem;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.tableItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showConfirmDialog(
          context,
          'Do you want to remove the item from the table?',
        );
      },
      onDismissed: (direction) {
        context.read<ReservationsManager>().removeItem(widget.dishId);
      },
      child: buildItemCard(context),
    );
  }

  Widget buildItemCard(BuildContext context) {
    final table = context.read<ReservationsManager>();
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.tableItem.imageUrl),
          ),
          title: Text(widget.tableItem.title),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Price: \$${tableItem?.price}'),
                Text('Total: \$${table.totalAmountItem(widget.dishId).toStringAsFixed(2)}'),
              ]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
              icon: const Icon(Icons.remove, size: 30),
              color: Colors.orangeAccent,
              onPressed: (() {
                table.minusQuantity(
                    context, widget.dishId, widget.tableItem);
                setState(() {
                  tableItem = table.getTableItem(widget.dishId);
                  print(tableItem?.quantity);
                });
              }),
            ),
            SizedBox(
              width: 20.0,
              height: 24.0,
              child: Center(
                child: Text(
                  '${tableItem?.quantity}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton(
              color: Colors.orangeAccent,
              icon: const Icon(Icons.add, size: 30),
              onPressed: (() {
                table.plusQuantity(widget.dishId, widget.tableItem);
                setState(() {
                  tableItem = table.getTableItem(widget.dishId);
                  print(tableItem?.quantity);
                });
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
