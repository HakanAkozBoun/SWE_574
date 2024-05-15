import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
//import 'package:recipe/widgets/home/testUser.dart';
import 'package:recipe/models/userProfile.dart';
import 'package:recipe/widgets/home/app_drawer.dart';
import 'package:recipe/widgets/home/appbar2.dart';

class OtherProfiles extends StatefulWidget {
  final int loggedInUserId;
  final int? clickedUserId;
  OtherProfiles(
      {required this.loggedInUserId, required this.clickedUserId, Key? key})
      : super(key: key);

  @override
  State<OtherProfiles> createState() => _OtherProfilesState();
}

Future<bool> checkFollowing(int loggedInUserId, int finalClickedUserId) async {
  bool exists =
      await UserProfile.FollowingExists(loggedInUserId, finalClickedUserId);
  return exists;
}

class _OtherProfilesState extends State<OtherProfiles> {
  late Future<UserProfile> ClickedUser;
  late int finalClickedUserId;
  late Future<bool> isFollowing;
  @override
  void initState() {
    super.initState();
    //EE
    finalClickedUserId = widget.clickedUserId ?? 1;
    isFollowing = checkFollowing(widget.loggedInUserId, finalClickedUserId);
    ClickedUser = UserProfile.fetchCurrentUser(finalClickedUserId);
  }

  List<Icon> allIcons = [
    Icon(Icons.work, color: maincolor),
    Icon(Icons.restaurant, color: maincolor),
    Icon(Icons.school, color: maincolor),
  ];
  List allTileNames = [
    'Working at: ',
    'Cuisines of expertise: ',
    'Graduated from: '
  ];

  List<Icon> followIcons = [
    Icon(Icons.work, color: maincolor),
    Icon(Icons.restaurant, color: maincolor),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar2(),
        drawer: AppDrawer(),
        backgroundColor: background,
        body: SafeArea(
            child: FutureBuilder<UserProfile>(
          future: ClickedUser,
          builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
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
              UserProfile ClickedUser = snapshot.data!;
              return Column(
                children: [
                  Text(
                    ClickedUser.user.username,
                    style:
                        TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
                  ),
                  FutureBuilder<bool>(
                      future: isFollowing,
                      builder: (BuildContext context,
                          AsyncSnapshot<bool> snapshotFollow) {
                        if (snapshotFollow.connectionState ==
                            ConnectionState.waiting) {
                          return Scaffold(
                            backgroundColor: background,
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshotFollow.hasError) {
                          return Scaffold(
                            backgroundColor: background,
                            body: Center(
                              child: Text('Error: ${snapshotFollow.error}'),
                            ),
                          );
                        } else if (snapshotFollow.hasData) {
                          bool isFollowing = snapshotFollow.data!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: followIcons[isFollowing ? 1 : 0],
                                onPressed: () {
                                  FollowUpdateFlow(widget.loggedInUserId,
                                      finalClickedUserId, isFollowing);

                                  setState(() {
                                    isFollowing = !isFollowing;
                                  });
                                },
                              ),
                            ],
                          );
                        } else {
                          return Scaffold(
                            backgroundColor: background,
                            body: Center(
                              child: Text("No follow data available"),
                            ),
                          );
                        }
                      }),
                  Divider(height: 40, thickness: 2),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      height: 40,
                      thickness: 2,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Container(
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: allIcons[index],
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            allTileNames[index] +
                                getRelevantText(ClickedUser, index),
                            style: TextStyle(fontSize: 17, color: font),
                          ),
                        ),
                      );
                    },
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Container(
                            width: 37,
                            height: 37,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: allIcons[index],
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              allTileNames[index] +
                                  getRelevantText(ClickedUser, index),
                              style: TextStyle(fontSize: 17, color: font),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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

  void FollowUpdateFlow(
      int loggedInUserId, int finalClickedUserId, bool isFollowing) {
    if (isFollowing) {
      Unfollow(loggedInUserId, finalClickedUserId);
    } else {
      Follow(loggedInUserId, finalClickedUserId);
    }
  }

  void Unfollow(int loggedInUserId, int finalClickedUserId) async {
    UserProfile.UnfollowUser(loggedInUserId, finalClickedUserId);
  }

  void Follow(int loggedInUserId, int finalClickedUserId) async {
    UserProfile.FollowUser(loggedInUserId, finalClickedUserId);
  }

  String getRelevantText(UserProfile user, int index) {
    switch (index) {
      case 0:
        return user.workingAt;
      case 1:
        return user.cuisinesOfExpertise;
      case 2:
        return user.graduatedFrom;
      default:
        return '';
    }
  }
}
