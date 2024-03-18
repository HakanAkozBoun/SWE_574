import 'package:flutter/material.dart';

import 'package:recipe/models/category.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final fetchedCategories = await Category.fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return buildCategory(
            '../../images/1c.jpg',
            category.name,
            onTap: () {
              print(category.name);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildCategory(String imagePath, String label, {VoidCallback? onTap}) {
    final width = 70.0;
    final height = 70.0;
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
