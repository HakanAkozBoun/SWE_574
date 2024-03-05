import 'package:flutter/material.dart';
import 'package:recipe/widgets/home/appbar2.dart';
import 'package:recipe/widgets/home/search_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Add this line to left-align the children
          children: [
            AppBar2(),

            //Search Bar
            const SearchBarWidget(),
          ],
        ),
      ),
    );
  }
}
