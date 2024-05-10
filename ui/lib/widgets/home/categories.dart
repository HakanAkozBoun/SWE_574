import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recipe/models/category.dart';

class CategoriesWidget extends StatefulWidget {
  final Function(int) onCategorySelected;
  const CategoriesWidget({Key? key, required this.onCategorySelected})
      : super(key: key);

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
            category.id,
            category.base64,
            category.name,
            onTap: () {
              setState(() {
                widget.onCategorySelected(category.id);
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildCategory(int categoryId, String imagePath, String label,
      {VoidCallback? onTap}) {
    final width = 70.0;
    final height = 70.0;
    var url = imagePath;
    Uint8List decodedImage = base64Decode(url);
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
                child: Image.memory(decodedImage, fit: BoxFit.cover),
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
