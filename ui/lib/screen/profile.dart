import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  @override
  List<Icon> icons = [
    Icon(Icons.person, color: maincolor),
    Icon(Icons.settings, color: maincolor),
    Icon(Icons.chat, color: maincolor),
    Icon(Icons.login, color: maincolor),
  ];
  List tileNames = [
    'Personal',
    'Settings',
    'FAQs',
    'Logout'
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: maincolor, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/Enes.jpg'),//buraya image ekleyeceğim
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Enes',
            style: TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 40,
              thickness: 2,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: icons[index],
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    tileNames[index],
                    style: TextStyle(fontSize: 17, color: font),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 15,
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}