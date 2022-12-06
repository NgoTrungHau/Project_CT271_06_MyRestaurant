import 'package:flutter/material.dart';
import 'package:flutter_application_myrestaurant/ui/reservations/reservations_manager.dart';
import 'package:flutter_application_myrestaurant/ui/reservations/reservations_item_card.dart';

import 'package:provider/provider.dart';

class ReservationList extends StatelessWidget {
  const ReservationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationsManager>(
        builder: (ctx, reservationsManager, child) {
      return ListView.builder(
        itemCount: reservationsManager.reservationCount,
        itemBuilder: (ctx, i) =>
            ReservationTableItem(reservationsManager.reservations[i]),
      );
    });
  }
}
