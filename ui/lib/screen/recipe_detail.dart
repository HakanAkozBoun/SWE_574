import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/screen/home.dart';

class Recipe extends StatelessWidget {
  Recipe({super.key});
  List icon = ['dough-rolling', 'cheese', 'meat', 'tomato', 'onion'];
  List value = ['250g', '120g', '100g', '50g', '30g'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'images/lunch3.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        width: 80,
                        height: 4,
                        color: font,
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                    radius: 18,
                    child: Icon(
                      Icons.favorite_border,
                      size: 25,
                      color: font,
                    ),
                  ),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                  radius: 18,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Home();
                          },
                        ),
                      );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: font,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'HamHamburger',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: font,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _getbody(),
            )
          ],
        ),
      ),
    );
  }



  Widget _getbody() {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              // Cooking Time Section
              _buildCookingTimeSection(),
              // Rating Section
              _buildRatingSection(),
              SizedBox(height: 10),
              // Ingredients Section
              _buildIngredientsSection(),
              // Nutrition Section
              _buildNutritionSection(),
              SizedBox(height: 10),
              // Recipe Steps Section
              _buildRecipeStepsSection(),
              // Comments Section
              _buildCommentsSection(),


            ],
          ),
        ),
      ],
    );
  }
Widget _buildRatingSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star, color: Colors.amber),
          SizedBox(height: 4),
          Text(
            '4.5',
            style: TextStyle(fontSize: 16, color: font, fontFamily: 'ro'),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildCookingTimeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Prep Time/Cooking Time',
            style: TextStyle(
              fontSize: 15,
              color: font,
              fontFamily: 'ro',
            ),
          ),
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: font),
              SizedBox(width: 5),
              Text(
                '25 min/15 min',
                style: TextStyle(
                  fontSize: 15,
                  color: font,
                  fontFamily: 'ro',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 20,
              color: font,
              fontFamily: 'ro',
            ),
          ),
          SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ...List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Container(
                        width: 90,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.grey,
                              blurRadius: 7,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('images/${icon[index]}.png'),
                              Text(
                                value[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: font,
                                  fontFamily: 'ro',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Facts',
            style: TextStyle(
              fontSize: 20,
              color: font,
              fontFamily: 'ro',
            ),
          ),
          SizedBox(height: 15),
          _nutritionFact('Calories', '200 kcal'),
          _nutritionFact('Fat', '10 g'),
          _nutritionFact('Sodium', '1.2 g'),
          _nutritionFact('Calcium', '130 mg'),
          _nutritionFact('Protein', '5 g'),
          _nutritionFact('Iron', '2.5 mg'),
          _nutritionFact('Carbohydrates', '35 g'),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _nutritionFact(String nutrient, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nutrient,
            style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'ro'),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'ro'),
          ),
        ],
      ),
    );
  }


  Widget _buildRecipeStepsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipe Steps',
            style: TextStyle(fontSize: 20, color: font, fontFamily: 'ro'),
          ),
          SizedBox(height: 5),
          Text(
            "1. Take the meat and mix it with the spices.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            "2. Grill the meat for 10 minutes.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            "3. Serve the meat with the vegetables.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
  Widget _buildCommentsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments',
            style: TextStyle(fontSize: 20, color: font, fontFamily: 'ro'),
          ),
          SizedBox(height: 10),
          Text(
            '"This recipe was fantastic!" *10* - Ahmedreza',
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
          Text(
            '"This recipe was ok." *5* - Metin',
            style: TextStyle(fontSize: 16, color: Colors.yellow),
          ),
          Text(
            '"Do not try this at home..." *1* - Milor',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
