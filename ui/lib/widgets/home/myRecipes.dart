import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/models/userProfile.dart';
import 'package:recipe/models/recipe.dart';

class MyRecipes extends StatefulWidget {
  MyRecipes({super.key});
  @override
  State<MyRecipes> createState() => _MyRecipes();
}

class _MyRecipes extends State<MyRecipes> {
  late Future<List<Recipe>> myRecipes;

  @override
  void initState() {
    super.initState();
    myRecipes = UserProfile.fetchSelfRecipes();
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
              /* Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          children: myRecipesList.map((recipe) {
                            return buildRecipeCard(recipe.title, recipe.excerpt,
                                '15 min', '../../images/dinner1.jpg');
                          }).toList(),
                        ),
                      ),*/

              /*
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          allTileNames[index] +
                              getRelevantText(currentUser, index),
                          style: TextStyle(fontSize: 17, color: font),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.navigate_next),
                        onPressed: () =>
                            _showAllSubPages(context, index, currentUser),
                      ),
                    );
                  },*/

              /*
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      children: myRecipesList.map((recipe) {
                        return buildRecipeCard(recipe.title, recipe.excerpt,
                            '15 min', '../../images/dinner1.jpg');
                      }).toList(),
                    ),
                  ),
                ),*/

              /*  return Scaffold(
                appBar: AppBar(
                  title: Text('Followed Accounts'),
                ),
                body: ListView.builder(
                  itemCount: followingUsersList.length,
                  itemBuilder: (context, index) {
                    UserProfile user = followingUsersList[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(user.image),
                        ),
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${user.user.username} ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ':     ${user.description} ',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OtherProfiles(user: user)),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
          */
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

/*
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: myRecipes.map((recipe) {
            return buildRecipeCard(recipe.title, recipe.excerpt, '15 min',
                '../../images/dinner1.jpg');
          }).toList(),
        ),
      ),
    );
  }
*/
  Widget cardList(BuildContext context, List<Recipe> myRecipes) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: myRecipes.map((recipe) {
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
