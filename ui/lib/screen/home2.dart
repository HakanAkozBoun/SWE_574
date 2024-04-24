import 'package:flutter/material.dart';
import 'package:recipe/widgets/home/appbar2.dart';
import 'package:recipe/widgets/home/categories.dart';
import 'package:recipe/widgets/home/recipe_list.dart';
import 'package:recipe/widgets/home/recommendation.dart';
import 'package:recipe/widgets/home/search_bar.dart';

class Home2 extends StatelessWidget {
  const Home2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Add this line to left-align the children
          children: [
            AppBar2(),

            //Search Bar
            const SearchBarWidget(),

            //Category
            buildSectionTitle('Category'),
            CategoriesWidget(),

            //Recommendations
            buildSectionTitle('Recommendations'),
            RecommendationWidget(),

            //Recipes List
            buildSectionTitle('Recipes List'),
            RecipeListWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
    );
  }
}