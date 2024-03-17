import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/backend_url.dart';

class Recipe {
  // Recipe url
  static const String recipeUrl = BackendUrl.apiUrl + 'blogs/';

  final int id;
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String contentTwo;
  final String image;
  final String ingredients;
  final String postLabel;
  final int category;

  Recipe({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.contentTwo,
    required this.image,
    required this.ingredients,
    required this.postLabel,
    required this.category,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      excerpt: json['excerpt'] ?? '',
      content: json['content'] ?? '',
      contentTwo: json['contentTwo'] ?? '',
      image: json['image'] ?? '',
      ingredients: json['ingredients'] ?? '',
      postLabel: json['postLabel'] ?? '',
      category: json['category'] ?? 0,
    );
  }

  static Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse(recipeUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Failed to load recipes');
    }
  }
}
