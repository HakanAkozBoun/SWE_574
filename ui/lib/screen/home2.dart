import 'package:flutter/material.dart';
import 'package:recipe/widgets/home/app_drawer.dart';
import 'package:recipe/widgets/home/appbar2.dart';
import 'package:recipe/widgets/home/categories.dart';
import 'package:recipe/widgets/home/recipe_list.dart';
import 'package:recipe/widgets/home/recommendation.dart';
import 'package:recipe/widgets/home/search_bar.dart';

class Home2 extends StatelessWidget {
  const Home2({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar2(),
      drawer: appDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
