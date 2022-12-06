import 'package:flutter/foundation.dart';

class Dish {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  final ValueNotifier<bool> _isFavorite;

  Dish({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageURL,
    isFavorite = false,
  }) : _isFavorite = ValueNotifier(isFavorite);

  Object? get quantity => null;
  
  set isFavorite(bool newValue) {
    _isFavorite.value = newValue;
  }

  bool get isFavorite {
    return _isFavorite.value;
  }

  ValueNotifier<bool> get isFavoriteListenable {
    return _isFavorite;
  }

  Dish copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageURL,
    bool? isFavorite,
  }) {
    return Dish(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageURL: imageURL ?? this.imageURL,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageURL,
    };
  }

  static Dish fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      imageURL: json['imageUrl'],
    );
  }
}