import 'package:flutter/material.dart';
import '../../models/recipe.dart';

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
            return buildRecipeCard(recipe.title, recipe.excerpt, '15 min',
                '../../images/dinner1.jpg');
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
                onTap: () {
                  print('clicked');
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    imagePath,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
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
