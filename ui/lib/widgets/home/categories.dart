import 'package:flutter/material.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  final width = 70.0;
  final height = 70.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildCategory('images/home/pizza.png', 'Category 1'),
          buildCategory('images/home/burger.png', 'Category 2'),
          buildCategory('images/home/drink.png', 'Category 3'),
          buildCategory('images/home/salan.png', 'Category 4'),
          buildCategory(
            'images/home/biryani.png',
            'Category 5',
          ),
        ],
      ),
    );
  }

  Widget buildCategory(String imagePath, String label, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
