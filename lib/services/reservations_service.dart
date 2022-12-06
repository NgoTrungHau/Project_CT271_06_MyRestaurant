import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_token.dart';
import '../models/reservation.dart';

import 'firebase_service.dart';

class ReservationsService extends FirebaseService {
  ReservationsService([AuthToken? authToken]) : super(authToken);

  Future<List<ReservationItem>> fetchReservations([bool filterByUser = false]) async {
    final List<ReservationItem> reservations = [];
    try {
      final filters = filterByUser ? 'createBy="creatorId"&equalTo="$userId"' : '';
      final reservationsUrl = Uri.parse('$databaseUrl/reservations.json?auth=$token&$filters');
      final response = await http.get(reservationsUrl);
      final reservationsMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(reservationsMap['error']);
        return reservations;
      }
      
      reservationsMap.forEach((reservationId, reservation)
      {
        // reservationsMap.add(
        //   ReservationItem.fromJson({
        //     'id': reservationId,
        //     ...reservation,
        //   }),
        // );
      });
      return reservations;
    } catch (error) {
      print(error);
      return reservations;
    }
  }

  // Future<ReservationItem?> addReservation(ReservationItem reservation) async {
  //   try {
  //     final url = Uri.parse('$databaseUrl/reservations.json?auth=$token');
  //     print(token);
  //     final response = await http.post(
  //       url,
  //       body: json.encode(
  //         reservation.toJson()
  //           ..addAll({
  //             'creatorId': userId,
  //           }),
  //       ),
  //     );
  //     if (response.statusCode != 200) {
  //       throw Exception(json.decode(response.body)['error']);
  //     }
  //     return reservation.copyWith(
  //       id: json.decode(response.body)['name'],
  //     );
  //   } catch (error) {
  //     print(error);
  //     return null;
  //   }
  // }

  // Future<bool> updateReservation(ReservationItem reservation) async {
  //   try {
  //     final url = Uri.parse('$databaseUrl/reservations/${reservation.id}.json?auth=$token');
  //     final response = await http.patch(
  //       url,
  //       body: json.encode(reservation.toJson()),
  //     );

  //     if(response.statusCode != 200) {
  //       throw Exception(json.decode(response.body)['error']);
  //     }

  //     return true;
  //   } catch (error) {
  //     print(error);
  //     return false;
  //   }
  // }

  // Future<bool> deleteReservation(String id) async {
  //   try {
  //     final url = Uri.parse('$databaseUrl/reservations/$id.json?auth=$token');
  //     final response = await http.delete(url);

  //     if(response.statusCode != 200) {
  //       throw Exception(json.decode(response.body)['error']);
  //     }

  //     return true;
  //   } catch (error) {
  //     print(error);
  //     return false;
  //   }
  // }
}