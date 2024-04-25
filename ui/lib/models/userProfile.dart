import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe.dart';
import '../constants/backend_url.dart';

class UserProfile {
  static const String currentUserUrl = BackendUrl.apiUrl + 'MyProfile/';
  static const String followingUsersUrl = BackendUrl.apiUrl + 'Following/';
  static const String bookmarkedRecipesUrl = BackendUrl.apiUrl + 'MyBookmarks/';
  static const String selfRecipesUrl = BackendUrl.apiUrl + 'MyRecipes/';

  final user;
  final int age;
  final double weight;
  final double height;
  final String description;
  final String image;
  final String experience;
  final String gender;
  final String graduatedFrom;
  final String cuisinesOfExpertise;
  final String workingAt;

  UserProfile({
    required this.user,
    required this.age,
    required this.weight,
    required this.height,
    required this.description,
    required this.image,
    required this.experience,
    required this.gender,
    required this.graduatedFrom,
    required this.cuisinesOfExpertise,
    required this.workingAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      user: json['user'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
      description: json['description'],
      image: json['image'],
      experience: json['experience'],
      gender: json['gender'],
      graduatedFrom: json['graduatedFrom'],
      cuisinesOfExpertise: json['cuisinesOfExpertise'],
      workingAt: json['workingAt'],
    );
  }

  static Future<UserProfile> fetchCurrentUser() async {
    final response =
        await http.get(Uri.parse(currentUserUrl)); // EE burada link doğru mu
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return UserProfile.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load current user');
    }
  }

  static Future<List<UserProfile>> fetchFollowingUsers() async {
    try {
      final response = await http.get(Uri.parse(followingUsersUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserProfile.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load following profiles');
      }
    } catch (e) {
      throw Exception('Failed to load following profiles');
    }
  }

  static Future<List<Recipe>> fetchBookmarkedRecipes() async {
    try {
      final response = await http.get(Uri.parse(bookmarkedRecipesUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookmarked recipes');
      }
    } catch (e) {
      throw Exception('Failed to load bookmarked recipes');
    }
  }

  static Future<List<Recipe>> fetchSelfRecipes() async {
    try {
      final response = await http.get(Uri.parse(selfRecipesUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load own recipes');
      }
    } catch (e) {
      throw Exception('Failed to load own recipes');
    }
  }
}