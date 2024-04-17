import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBar2 extends StatelessWidget {
  const AppBar2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 15,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
          onTap: () {
            print('Clicked');
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const Icon(CupertinoIcons.bars),
          ),
        )
      ]),
    );
  }
}
