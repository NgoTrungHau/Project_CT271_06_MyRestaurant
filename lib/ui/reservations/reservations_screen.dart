import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/app_drawer.dart';
import 'reservations_list.dart';
import 'reservations_manager.dart';
import 'edit_table_screen.dart';
import 'table_grid_tile.dart';

class ReservationScreen extends StatefulWidget {
  static const routeName = '/reservation';

  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late Future<void> _fetchTables;
  int _selectedIndex = 0;
  static final List<Widget> _pages = [
    const TableGridTile(),
    const ReservationList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTables = context.read<ReservationsManager>().fetchTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book table',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          )
        ),
        actions: <Widget>[
          buildAddButton(context),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 237, 205),
      drawer: const AppDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.table_bar),
            label: 'Tables',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Reservations',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildAddButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditTableScreen.routeName,
        );
      },
    );
  }
}
