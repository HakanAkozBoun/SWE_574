import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';

PreferredSizeWidget appbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Icon(
      Icons.menu,
      size: 27,
    ),
    backgroundColor: maincolor,
  );
}
