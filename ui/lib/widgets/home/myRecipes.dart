import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/models/userProfile.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/widgets/home/app_drawer.dart';
import 'package:recipe/widgets/home/appbar2.dart';

class MyRecipes extends StatefulWidget {
  final int userId;

  MyRecipes({required this.userId, Key? key}) : super(key: key);
  @override
  State<MyRecipes> createState() => _MyRecipes();
}

class _MyRecipes extends State<MyRecipes> {
  late Future<List<Recipe>> myRecipes;

  @override
  void initState() {
    super.initState();
    myRecipes = UserProfile.fetchSelfRecipes(widget.userId);
    // loadMyRecipes();
  }

/*
  Future<void> loadMyRecipes() async {
    try {
      final fetchedMyRecipes = await UserProfile.fetchSelfRecipes();
      setState(() {
        myRecipes = fetchedMyRecipes;
      });
    } catch (e) {
      print('Error loading own recipes : $e');
    }
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar2(),
        drawer: AppDrawer(),
        backgroundColor: background,
        body: SafeArea(
            child: FutureBuilder<List<Recipe>>(
          future: myRecipes,
          builder:
              (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: background,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                backgroundColor: background,
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else if (snapshot.hasData) {
              List<Recipe> myRecipesList = snapshot.data!;
              return cardList(context, myRecipesList);
            } else {
              return Scaffold(
                backgroundColor: background,
                body: Center(
                  child: Text("No data available"),
                ),
              );
            }
          },
        )));
  }

  Widget cardList(BuildContext context, List<Recipe> myRecipes) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: myRecipes.map((recipe) {
            return buildRecipeCard(recipe.title, recipe.excerpt,
                recipe.preparationtime.toString() + ' min');
          }).toList(),
        ),
      ),
    );
  }

  Widget buildRecipeCard(
    String title,
    String description,
    String duration,
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
