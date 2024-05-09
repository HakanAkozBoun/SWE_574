import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/backend_url.dart';

class Recipe {
  // Recipe url
  static const String recipeUrl = BackendUrl.apiUrl + 'PopularPostsApiView/';

  final int id;
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String contentTwo;
  final String preparationtime;
  final String cookingtime;
  final double avg_rating;
  final int image;
  final String ingredients;
  final String postLabel;
  final int userid;
  final int serving;
  final String base64;
  final String type;
  final int category_id;
  final String rate;
  final String bookmark;

  Recipe({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.contentTwo,
    required this.preparationtime,
    required this.cookingtime,
    required this.avg_rating,
    required this.image,
    required this.ingredients,
    required this.postLabel,
    required this.userid,
    required this.serving,
    required this.base64,
    required this.type,
    required this.category_id,
    required this.rate,
    required this.bookmark,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      excerpt: json['excerpt'] ?? '',
      content: json['content'] ?? '',
      contentTwo: json['contentTwo'] ?? '',
      preparationtime: json['preparationtime'] ?? '',
      cookingtime: json['cookingtime'] ?? '',
      avg_rating: json['avg_rating'] ?? 0.0,
      image: json['image'] ?? 0,
      ingredients: json['ingredients'] ?? '',
      postLabel: json['postLabel'] ?? '',
      userid: json['userid'] ?? 0,
      serving: json['serving'] ?? 0,
      base64: json['base64'] ?? '',
      type: json['type'] ?? '',
      category_id: json['category_id'] ?? 0,
      rate: json['rate'] ?? '',
      bookmark: json['bookmark'] ?? '',
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

class Recommendation {
  static const String recipeUrl = BackendUrl.apiUrl + 'recommend/';

  final int id;
  final String imagePath;
  final String title;
  final String description;
  final String duration;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.imagePath,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['excerpt'] ?? '',
      duration: json['duration'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }

  static Future<List<Recommendation>> fetchRecommendation() async {
    try {
      final response = await http.get(Uri.parse(recipeUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recommendation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      throw Exception('Failed to load recommendations');
    }
  }
}
