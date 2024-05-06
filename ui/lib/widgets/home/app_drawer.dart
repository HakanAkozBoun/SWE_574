import 'package:flutter/material.dart';
import 'package:recipe/screen/addPost.dart';
import 'package:recipe/screen/login.dart';
import 'package:recipe/screen/home2.dart';
import 'package:recipe/screen/profile.dart';

class appDrawer extends StatelessWidget {
  const appDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xfff96163),
            ),
            child: Text(
              'Cookpad By Chefs',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'ro',
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Home2(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('MyProfile'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Profile(userId: 7),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Add recipe'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => AddItemPage(edit: 0, item: {}, id: 0)),
              );
            },
          ),
        ],
      ),
    );
  }
}