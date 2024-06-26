import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe.dart';
import '../constants/backend_url.dart';

class UserProfile {
  // static const String currentUserUrl = BackendUrl.apiUrl + 'MyProfile/';
  //static const String followingUsersUrl = BackendUrl.apiUrl + 'Following/';
  //static const String bookmarkedRecipesUrl = BackendUrl.apiUrl + 'MyBookmarks/';
  //static const String selfRecipesUrl = BackendUrl.apiUrl + 'MyRecipes/';

  final int profileId;
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

  UserProfile({
    required this.profileId,
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
      profileId: json['id'],
      user: User.fromJson(json['user']),
      age: json['age'] ?? 0,
      weight: json['weight'] ?? 0,
      height: json['height'] ?? 0,
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      experience: json['experience'] ?? 0,
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

  static Future<UserProfile> updateUserProfile(
      int userId, Map<String, dynamic> map) async {
    var url = Uri.parse('${BackendUrl.updateUserProfile}?id=$userId');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(map),
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  static Future<UserProfile> updateUser(
      int userId, Map<String, dynamic> map) async {
    var url = Uri.parse('${BackendUrl.updateUser}?id=$userId');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(map),
      );

      if (response.statusCode == 200) {
        print(response.body);

        return UserProfile.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  static Future<bool> UsernameExists(int userId, String username) async {
    var queryParams = {
      'user_id': userId.toString(),
      'username': username,
    };

    var uri = Uri.parse(BackendUrl.checkUsernameAvailability)
        .replace(queryParameters: queryParams);

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['exists'];
      } else {
        throw Exception(
            'Failed to check username availability. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check username availability: $e');
    }
  }

  static Future<bool> EmailExists(int userId, String email) async {
    var queryParams = {
      'user_id': userId.toString(),
      'email': email,
    };

    var uri = Uri.parse(BackendUrl.checkEmailAvailability)
        .replace(queryParameters: queryParams);

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['exists'];
      } else {
        throw Exception(
            'Failed to check email availability. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check email availability: $e');
    }
  }

  static Future<bool> FollowingExists(
      int loggedInUserId, int clickedUserId) async {
    var queryParams = {
      'logged_in_user_id': loggedInUserId.toString(),
      'other_user_id': clickedUserId.toString(),
    };

    var uri = Uri.parse(BackendUrl.checkFollowing)
        .replace(queryParameters: queryParams);

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['exists'];
      } else {
        throw Exception(
            'Failed to check following status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check following status: $e');
    }
  }

  static Future<bool> FollowUser(int loggedInUserId, int clickedUserId) async {
    var queryParams = {
      'logged_in_user_id': loggedInUserId.toString(),
      'other_user_id': clickedUserId.toString(),
    };

    var uri =
        Uri.parse(BackendUrl.followUser).replace(queryParameters: queryParams);

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['followed'];
      } else {
        throw Exception(
            'Failed to follow user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to follow user: $e');
    }
  }

  static Future<bool> UnfollowUser(
      int loggedInUserId, int clickedUserId) async {
    var queryParams = {
      'logged_in_user_id': loggedInUserId.toString(),
      'other_user_id': clickedUserId.toString(),
    };

    var uri = Uri.parse(BackendUrl.unfollowUser)
        .replace(queryParameters: queryParams);

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['unfollowed'];
      } else {
        throw Exception(
            'Failed to unfollow user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to unfollow user: $e');
    }
  }
}

class User {
  final String username;
  final String email;
  final int id;
  User({required this.username, required this.email, required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      id: json['id'],
    );
  }
}
