import 'package:flutter/material.dart';
import 'otherProfiles.dart';
import 'testUser.dart';

class Following extends StatelessWidget {
  final List<TestUser> followedUsers = [
    TestUser(
        id: '1',
        username: 'User1',
        profileImageUrl: "./images/dinner0.jpg",
        description: 'User1Description'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followed Accounts'),
      ),
      body: ListView.builder(
        itemCount: followedUsers.length,
        itemBuilder: (context, index) {
          TestUser user = followedUsers[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(user.profileImageUrl),
              ),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${user.username} ', // Add a space at the end for separation
                      style: TextStyle(
                        color: Colors.black, // Your username text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:':     ${user.description} ',
                      style: TextStyle(
                        color: Colors.grey, // Your additional info text color
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
