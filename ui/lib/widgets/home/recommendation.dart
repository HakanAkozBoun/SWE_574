import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recipe/helpers/userData.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/screen/recipe.dart' as RecipeScreen;

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({super.key});

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  late List<Recommendation> recommendations = [];
  UserData user = UserData();
  var userId;
  @override
  void initState() {
    super.initState();
    userId = user.getUserId();
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    try {
      final fetchedRecommendations =
          await Recommendation.fetchRecommendation(userId.toString());
      setState(() {
        recommendations = fetchedRecommendations;
      });
    } catch (e) {
      print('Error loading recommendations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: recommendations.map(
            (recommendation) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => RecipeScreen.Recipe(
                        slug: "Recipe",
                        id: recommendation.id,
                      ),
                    ),
                  );
                },
                child: buildRecommendation(
                    recommendation.title,
                    recommendation.description,
                    recommendation.preparationtime,
                    recommendation.cookingtime,
                    recommendation.avg_rating.toStringAsFixed(1),
                    recommendation.base64),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  final double width = 170.0;
  final double height = 270.0;

  Widget buildRecommendation(String title, String description, String preptime,
      String cookingtime, String star, String imagePath) {
    var url = imagePath;
    Uint8List decodedImage = base64Decode(url);

    int prepTimeInt = int.tryParse(preptime) ?? 0;
    int cookingTimeInt = int.tryParse(cookingtime) ?? 0;
    int totalTime = prepTimeInt + cookingTimeInt;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 130,
                child: Image.memory(decodedImage),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: width - 20,
                height: 20,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: width - 20,
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  width: width - 20,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total time: $totalTime min",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 5),
              SizedBox(
                width: width - 20,
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      star,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Color.fromRGBO(255, 152, 0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
