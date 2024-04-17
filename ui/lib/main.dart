import 'package:flutter/material.dart';
import 'package:recipe/screen/splash.dart';
import 'package:recipe/screen/tracking_diet_goals.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrackingDietGoals(),
      debugShowCheckedModeBanner: false,
    );
  }
}
