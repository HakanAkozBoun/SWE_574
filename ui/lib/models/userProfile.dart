import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe.dart';
import '../constants/backend_url.dart';

class UserProfile {
  // static const String currentUserUrl = BackendUrl.apiUrl + 'MyProfile/';
  //static const String followingUsersUrl = BackendUrl.apiUrl + 'Following/';
  //static const String bookmarkedRecipesUrl = BackendUrl.apiUrl + 'MyBookmarks/';
  //static const String selfRecipesUrl = BackendUrl.apiUrl + 'MyRecipes/';

  final int id;
  final User user;
  //final String username;
  //final String email;
  final int age;
  final double weight;
  final double height;
  final String description;
  final String image;
  final int experience;
  final String gender;
  final String graduatedFrom;
  final String cuisinesOfExpertise;
  final String workingAt;
  final String story;
  //final String foodAllergies;
  final String dietGoals;

  UserProfile({
    required this.id,
    required this.user,
    //required this.username,
    //required this.email,
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
    required this.story,
    //required this.foodAllergies,
    required this.dietGoals,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      user: User.fromJson(json['user']),
      // username: json['username'] ?? '',
      // email: json['email'] ?? '',
      age: json['age'] ?? 0,
      weight: json['weight'] ?? '',
      height: json['height'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      experience: json['experience'] ?? 0,
      story: json['story'] ?? '',
      // foodAllergies: json['food_allergies'] ?? '',
      dietGoals: json['diet_goals'] ?? '',
      gender: json['gender'] ?? '',
      graduatedFrom: json['graduated_from'] ?? '',
      cuisinesOfExpertise: json['cuisines_of_expertise'] ?? '',
      workingAt: json['working_at'] ?? '',
    );
  }

  static Future<UserProfile> fetchCurrentUser(int userId) async {
    final response = await http.get(Uri.parse(
        '${BackendUrl.currentUserUrl}?id=$userId')); // EE burada link doğru mu
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return UserProfile.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load current user');
    }
  }

  static Future<List<UserProfile>> fetchFollowingUsers(int userId) async {
    try {
      //final response = await http.get(Uri.parse(BackendUrl.followingUsersUrl));
      final response = await http
          .get(Uri.parse('${BackendUrl.followingUsersUrl}?id=$userId'));
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

  static Future<List<Recipe>> fetchBookmarkedRecipes(int userId) async {
    try {
      final response = await http
          .get(Uri.parse('${BackendUrl.bookmarkedRecipesUrl}?id=$userId'));
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

  static Future<List<Recipe>> fetchSelfRecipes(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('${BackendUrl.selfRecipesUrl}?id=$userId'));
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

class User {
  final String username;
  final String email;

  User({required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
    );
  }
}
