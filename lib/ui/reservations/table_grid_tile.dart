import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'table_grid.dart';
import 'reservations_manager.dart';
class TableGridTile extends StatefulWidget {
  const TableGridTile(
    {super.key});

  @override
  State<TableGridTile> createState() => _TableGridTileState();
}

class _TableGridTileState extends State<TableGridTile> {
  late Future<void> _fetchTables;

  @override
  void initState() {
    super.initState();
    _fetchTables = context.read<ReservationsManager>().fetchTables();
  }

  @override
  Widget build(BuildContext context){
    return Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<ReservationsManager>(
              builder: (ctx, reservationsManager, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: reservationsManager.tableCount,
                  itemBuilder: (ctx, i) => TableGrid(reservationsManager.tables[i]),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4/2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                );
              }
            ),

          )
          
        ],
      );
  }
}