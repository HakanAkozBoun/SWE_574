import 'package:flutter/material.dart';
import 'package:recipe/screen/home.dart';
import 'package:recipe/screen/splash.dart';
import 'package:recipe/screen/Profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
