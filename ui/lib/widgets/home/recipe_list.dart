import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/screen/recipe.dart' as RecipeScreen;

class RecipeListWidget extends StatefulWidget {
  const RecipeListWidget({Key? key}) : super(key: key);

  @override
  _RecipeListWidgetState createState() => _RecipeListWidgetState();
}

class _RecipeListWidgetState extends State<RecipeListWidget> {
  late List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    try {
      final fetchedRecipes = await Recipe.fetchRecipes();
      setState(() {
        recipes = fetchedRecipes;
      });
    } catch (e) {
      print('Error loading recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: recipes.map((recipe) {
            return GestureDetector(
              onTap: () {
                // Handle tap event here
                // For example, navigate to RecipeScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => RecipeScreen.Recipe(
                      slug: recipe.slug.toString(),
                      id: recipe.id,
                    ),
                  ),
                );
              },
              child: buildRecipeCard(recipe.title, recipe.excerpt,
                  "recipe.duration", recipe.base64),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildRecipeCard(
    String title,
    String description,
    String duration,
    String imagePath,
  ) {
    var url = imagePath;
    Uint8List decodedImage = base64Decode(url);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  child: Image.memory(decodedImage),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        color: Color.fromRGBO(255, 152, 0, 1),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
