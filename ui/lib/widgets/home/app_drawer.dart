import 'package:flutter/material.dart';
import 'package:recipe/screen/addPost.dart';
import 'package:recipe/screen/login.dart';
import 'package:recipe/screen/home2.dart';
import 'package:recipe/screen/profile.dart';
import 'package:recipe/helpers/userData.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  UserData user = UserData();
  var userId;

  @override
  void initState() {
    super.initState();
    userId = user.getUserId();
  }

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
          if (userId != null && userId != 0) ...[
            ListTile(
              title: const Text('MyProfile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Profile(userId: userId),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Add recipe'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddItemPage(edit: 0, item: {}, id: 0)),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Handle logout logic here
              },
            ),
          ],
          if (userId == null || userId == 0) ...[
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
          ],
        ],
      ),
    );
  }
}
