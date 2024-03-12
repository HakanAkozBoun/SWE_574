import 'package:flutter/material.dart';

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({super.key});

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  final width = 170.0;
  final height = 250.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: [
            buildRecommendation(
              'images/home/burger.png',
              'Hot Burger',
              'This is a description of the recipe',
              '30 min',
            ),
            buildRecommendation(
              'images/home/pizza.png',
              'Pepperoni Pizza',
              'This is a description of the recipe',
              '45 min',
            ),
            buildRecommendation(
              'images/home/biryani.png',
              'Biryani',
              'This is a description of the recipe',
              '15 min',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecommendation(
      String imagePath, String title, String description, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  imagePath,
                  height: 130,
                ),
              ),
              const SizedBox(height: 10), // Add this SizedBox for distance
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10), // Add this SizedBox for distance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    duration,
                    style: const TextStyle(
                      fontSize: 20,
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
      ),
    );
  }
}
