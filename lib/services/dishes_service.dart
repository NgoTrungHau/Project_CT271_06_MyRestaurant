import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dish.dart';
import '../models/auth_token.dart';

import 'firebase_service.dart';

class DishesService extends FirebaseService {
  DishesService([AuthToken? authToken]) : super(authToken);

  Future<List<Dish>> fetchDishes([bool filterByUser = false]) async {
    final List<Dish> dishes = [];
    try {
      final filters = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final dishesUrl = Uri.parse('$databaseUrl/dishes.json?auth=$token&$filters');
      final response = await http.get(dishesUrl);
      final dishesMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(dishesMap['error']);
        return dishes;
      }

      final userFavoritesUrl = Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesResponse = await http.get(userFavoritesUrl);
      final userFavoritesMap = json.decode(userFavoritesResponse.body);

      dishesMap.forEach((dishId, dish)
      {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[dishId] ?? false);
        dishes.add(
          Dish.fromJson({
            'id': dishId,
            ...dish,
          }).copyWith(isFavorite: isFavorite),
        );
      });
      return dishes;
    } catch (error) {
      print(error);
      return dishes;
    }
  }

  Future<Dish?> addDish(Dish dish) async {
    try {
      final url = Uri.parse('$databaseUrl/dishes.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(
          dish.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return dish.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateDish(Dish dish) async {
    try {
      final url = Uri.parse('$databaseUrl/dishes/${dish.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(dish.toJson()),
      );

      if(response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteDish(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/dishes/$id.json?auth=$token');
      final response = await http.delete(url);

      if(response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveFavoriteStatus(Dish dish) async {
    try {
      final url = Uri.parse('$databaseUrl/userFavorites/$userId/${dish.id}.json?auth=$token');
      final response = await http.put(
        url,
        body: json.encode(
          dish.isFavorite,
        ),
      );

      if(response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}