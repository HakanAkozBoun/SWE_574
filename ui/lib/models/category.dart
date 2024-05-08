import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/backend_url.dart';

class Category {
  static const String categoryUrl = BackendUrl.apiUrl + 'CategoryList/';

  final int id;
  final String name;
  final String image;
  final String base64;
  final String type;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.base64,
    required this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      base64: json['base64'] ?? '',
      type: json['type'] ?? '',
    );
  }

  static Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(categoryUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }
}
