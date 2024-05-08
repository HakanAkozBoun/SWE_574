import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';

class AppBar2 extends StatelessWidget implements PreferredSizeWidget {
  const AppBar2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Cookpad By Chefs'),
      backgroundColor: maincolor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
