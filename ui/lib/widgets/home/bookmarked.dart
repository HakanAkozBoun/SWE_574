import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/models/userProfile.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/widgets/home/app_drawer.dart';
import 'package:recipe/widgets/home/appbar2.dart';

class Bookmarked extends StatefulWidget {
  final int userId;

  Bookmarked({required this.userId, Key? key}) : super(key: key);

  @override
  State<Bookmarked> createState() => _BookmarkedState();
}

class _BookmarkedState extends State<Bookmarked> {
  late Future<List<Recipe>> bookmarkedRecipes;

  @override
  void initState() {
    super.initState();
    bookmarkedRecipes = UserProfile.fetchBookmarkedRecipes(widget.userId);
    // loadBookmarkedRecipes();
  }

/*
  Future<void> loadBookmarkedRecipes() async {
    try {
      final fetchedBookmarkedRecipes =
          await UserProfile.fetchBookmarkedRecipes();
      setState(() {
        bookmarkedRecipes = fetchedBookmarkedRecipes;
      });
    } catch (e) {
      print('Error loading bookmarked recipes: $e');
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
          future: bookmarkedRecipes,
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
              List<Recipe> bookmarkedRecipesList = snapshot.data!;
              return cardList(context, bookmarkedRecipesList);
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

  Widget cardList(BuildContext context, List<Recipe> bookmarkedRecipesList) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: bookmarkedRecipesList.map((recipe) {
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
