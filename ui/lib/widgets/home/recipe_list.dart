import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/screen/recipe.dart' as RecipeScreen;

class RecipeListWidget extends StatefulWidget {
  final int selectedCategoryId;

  const RecipeListWidget({Key? key, required this.selectedCategoryId})
      : super(key: key);

  @override
  _RecipeListWidgetState createState() => _RecipeListWidgetState();
}

class _RecipeListWidgetState extends State<RecipeListWidget> {
  late List<Recipe> recipes = [];
  List<Recipe> filteredRecipes = [];

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
        filterRecipesByCategory(widget.selectedCategoryId);
      });
    } catch (e) {
      print('Error loading recipes: $e');
    }
  }

  void filterRecipesByCategory(int categoryId) {
    setState(() {
      if (categoryId == 0) {
        filteredRecipes = List.from(recipes);
      } else {
        filteredRecipes = recipes
            .where((recipe) => recipe.category_id == categoryId)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: filteredRecipes.map((recipe) {
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
              child: buildRecipeCard(
                recipe.title,
                recipe.excerpt,
                recipe.preparationtime,
                recipe.cookingtime,
                recipe.avg_rating.toString(),
                recipe.base64,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildRecipeCard(
    String title,
    String description,
    String preptime,
    String cookingtime,
    String star,
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
                  Text(
                    "Cooking time: " + cookingtime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Preparation time: " + preptime,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Row(
                        // Adding a Row widget to contain the icon and text
                        children: [
                          Text(
                            star, // Your additional text here
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Adjust as needed
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Color.fromRGBO(255, 152, 0, 1),
                          ),
                        ],
                      ),
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
