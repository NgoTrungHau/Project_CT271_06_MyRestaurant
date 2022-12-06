import 'package:flutter/material.dart';
import '../../models/table.dart';
import 'book_table_screen.dart';

class TableGrid extends StatelessWidget {
  final TableB table;
  const TableGrid(
    this.table, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(15),
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              BookScreen.routeName,
              arguments: table.id,
            );
          },
          child: Center(
              child: Row(children: <Widget>[
            SizedBox(
                width: 120,
                height: 20,
                child: Text(
                  table.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
            const SizedBox(
                width: 12,
                height: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                )),
          ])),
        ));
  }
}
