import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.5, // ekranın tamamını kaplamasın diye
      child: Column(
        children: [
          SizedBox(height: 50),
          Center(
            child: Text(
              "Are you sure you want to log out?",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: font,
                  fontFamily: 'ro'),
            ),
          ),
          SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 50),
              IconButton(
                iconSize: 100,
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 50),
              IconButton(
                iconSize: 100,
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  //bunlar eklenmeli
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
