import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/reservation.dart';

class ReservationTableItem extends StatefulWidget {
  final ReservationItem reservationItem;
  const ReservationTableItem(this.reservationItem, {super.key});

  @override
  State<ReservationTableItem> createState() => _ReservationItemState();
}

class _ReservationItemState extends State<ReservationTableItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          buildReservationSummary(),
          if (_expanded) buildReservationDetails()
        ],
      ),
    );
  }

  Widget buildReservationDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      height: (widget.reservationItem.dishCount * 45.0 + 10),
      child: ListView(
        children: widget.reservationItem.dishes
            .map(
              (prod) => Padding(
                padding:const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(prod.imageUrl),
                        ),
                        const SizedBox(width:20),
                        Text(
                          prod.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,  
                          ),
                        ),
                          ],
                    ),
                    Text(
                      '${prod.quantity} x \$${prod.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildReservationSummary() {
    return ListTile(
      title: Text(
          '${widget.reservationItem.tableTitle}:   \$${widget.reservationItem.amount}',
          style: const TextStyle(fontWeight: FontWeight.bold)
          ),
      subtitle: Text(
        DateFormat('dd/MM/yyyy hh:mm').format(widget.reservationItem.dateTime),
      ),
      trailing: IconButton(
        icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        onPressed: () {
          setState(() {
            _expanded = !_expanded;
          });
        },
      ),
    );
  }
}
