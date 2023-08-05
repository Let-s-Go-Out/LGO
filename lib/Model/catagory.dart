import 'package:flutter/material.dart';

class Category {
  final int id;
  final String title;
  final IconData iconData;

  Category(this.id, this.title, this.iconData);
}

List<Category> categoryList = [
  Category(1, "음식점", Icons.restaurant), // type = restaurant
  Category(1, "카페", Icons.coffee), // type = cafe
  Category(1, "공원", Icons.park_outlined), // type = park
  Category(1, "쇼핑", Icons.shopping_bag_outlined), // type = shopping_mall
  Category(1, "어트랙션", Icons.attractions_outlined), // type = tourist_attraction
  Category(1, "박물관", Icons.museum), // type = museum
];