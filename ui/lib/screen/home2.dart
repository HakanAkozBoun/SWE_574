import 'package:flutter/material.dart';
import 'package:recipe/widgets/home/app_drawer.dart';
import 'package:recipe/widgets/home/appbar2.dart';
import 'package:recipe/widgets/home/categories.dart';
import 'package:recipe/widgets/home/recipe_list.dart';
import 'package:recipe/widgets/home/recommendation.dart';

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  int selectedCategoryId = -1;
  
  void updateSelectedCategory(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar2(),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            // const SearchBarWidget(),

            buildSectionTitle('Category'),
            CategoriesWidget(
              onCategorySelected: updateSelectedCategory,
            ),

            buildSectionTitle("Recommendations"),
            RecommendationWidget(),

            buildSectionTitle('Recipes List'),
            RecipeListWidget(
              selectedCategoryId: selectedCategoryId,
            ),
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
