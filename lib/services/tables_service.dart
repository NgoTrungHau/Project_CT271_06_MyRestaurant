import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_token.dart';
import '../models/table.dart';

import 'firebase_service.dart';

class TablesService extends FirebaseService {
  TablesService([AuthToken? authToken]) : super(authToken);

  Future<List<TableB>> fetchTables([bool filterByUser = false]) async {
    final List<TableB> tables = [];
    try {
      final filters = filterByUser ? 'createBy="creatorId"&equalTo="$userId"' : '';
      final tablesUrl = Uri.parse('$databaseUrl/tables.json?auth=$token&$filters');
      final response = await http.get(tablesUrl);
      final tablesMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(tablesMap['error']);
        return tables;
      }
      
      tablesMap.forEach((tableId, table)
      {
        tables.add(
          TableB.fromJson({
            'id': tableId,
            ...table,
          }),
        );
      });
      return tables;
    } catch (error) {
      print(error);
      return tables;
    }
  }

  Future<TableB?> addTable(TableB table) async {
    try {
      final url = Uri.parse('$databaseUrl/tables.json?auth=$token');
      print(token);
      final response = await http.post(
        url,
        body: json.encode(
          table.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return table.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateTable(TableB table) async {
    try {
      final url = Uri.parse('$databaseUrl/tables/${table.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(table.toJson()),
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

  Future<bool> deleteTable(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/tables/$id.json?auth=$token');
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
}