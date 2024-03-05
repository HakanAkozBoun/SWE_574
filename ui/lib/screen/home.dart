import 'package:flutter/material.dart';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/consent/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indexx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(),
      body: CustomScrollView(),
    );
  }
}
