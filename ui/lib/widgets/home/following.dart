import 'package:flutter/material.dart';
import 'package:recipe/models/userProfile.dart';
import 'otherProfiles.dart';
import 'testUser.dart';

class Following extends StatefulWidget {
  late UserProfile currentUser;
  Following(this.currentUser, {Key? key}) : super(key: key);

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  late List<UserProfile> followingUsers = [];

  @override
  void initState() {
    super.initState();
    loadFollowingUsers();
  }

  Future<void> loadFollowingUsers() async {
    try {
      final fetchedFollowingUsers = await UserProfile.fetchFollowingUsers();
      setState(() {
        followingUsers = fetchedFollowingUsers;
      });
    } catch (e) {
      print('Error loading following users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followed Accounts'),
      ),
      body: ListView.builder(
        itemCount: followingUsers.length,
        itemBuilder: (context, index) {
          UserProfile user = followingUsers[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(user.image),
              ),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${user.user.username} ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ':     ${user.description} ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtherProfiles(user: user)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
