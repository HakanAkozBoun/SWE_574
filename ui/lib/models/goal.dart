import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe/constants/backend_url.dart';

class Goal {
  final String? goalNutrition;
  final double? goalAmount;

  Goal({
    this.goalNutrition,
    this.goalAmount,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      goalNutrition: json['goal_nutrition'],
      goalAmount: json['goal_amount'],
    );
  }
  static Future<List<Goal>> fetchGoals(int userId) async {
    final response =
        await http.get(Uri.parse('${BackendUrl.goals}?user_id=$userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Goal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load goals');
    }
  }
 static Future<List<Goal>> fetchAverageGoals(int userId) async {
    final response =
        await http.get(Uri.parse('${BackendUrl.goals}?user_id=$userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Goal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load goals');
    }
  }
  Future<bool> createGoal(
      int userId, String goalName, double goal_Amount) async {
    print(goalName);
    print(goal_Amount);
    var url = Uri.parse('${BackendUrl.createGoal}?id=$userId');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'goal_name': goalName,
          'amount': goal_Amount,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to create goal: $e');
    }
  }

  Future<bool> updateGoal(
      int userId, String goalName, double goal_Amount) async {
    var url = Uri.parse('${BackendUrl.updateGoal}?id=$userId');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'goal_name': goalName,
          'amount': goal_Amount,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to update goal: $e');
    }
  }
}
