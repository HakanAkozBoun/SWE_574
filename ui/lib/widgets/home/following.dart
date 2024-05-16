import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/models/userProfile.dart';
import 'otherProfiles.dart';
//import 'testUser.dart';

// EE kimseyi takip etmiyorsa testi lazım
// ignore: must_be_immutable
class Following extends StatefulWidget {
  final int userId;

  Following({required this.userId, Key? key}) : super(key: key);
  //Following({super.key});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  //late Future<UserProfile> currentUser;
  late Future<List<UserProfile>> followingUsers;

  @override
  void initState() {
    super.initState();
    // currentUser = apiCalls.fetchCurrentUser();
    followingUsers = UserProfile.fetchFollowingUsers(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: SafeArea(
            child: FutureBuilder<List<UserProfile>>(
          future: followingUsers,
          builder: (BuildContext context,
              AsyncSnapshot<List<UserProfile>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: background,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                backgroundColor: background,
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else if (snapshot.hasData) {
              List<UserProfile> followingUsersList = snapshot.data!;
              return Scaffold(
                appBar: AppBar(
                  title: Text('Followed Accounts'),
                ),
                body: ListView.builder(
                  itemCount: followingUsersList.length,
                  itemBuilder: (context, index) {
                    UserProfile user = followingUsersList[index];
                    return Card(
                      child: ListTile(
                        /*leading: CircleAvatar(
                          backgroundImage: AssetImage(user.image),
                        ),*/
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
                                builder: (context) => OtherProfiles(
                                    loggedInUserId: widget.userId,
                                    clickedUserId: user.user.id)),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: background,
                body: Center(
                  child: Text("No data available"),
                ),
              );
            }
          },
        )));
  }
}
