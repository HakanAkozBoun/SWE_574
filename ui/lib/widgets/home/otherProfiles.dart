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

  List followTexts = ['Tap the heart to Unfollow', 'Tap the heart to follow'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar2(),
        drawer: AppDrawer(),
        backgroundColor: background,
        body: SafeArea(
            child: FutureBuilder<UserProfileData>(
          future: fetchData(),
          builder:
              (BuildContext context, AsyncSnapshot<UserProfileData> snapshot) {
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
              final userProfileData = snapshot.data!;
              return Column(
                children: [
                  Text(
                    userProfileData.userProfile.user.username,
                    style:
                        TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
                  ),
                  Text(
                    followTexts[userProfileData.isFollowing ? 0 : 1],
                  ),
                  IconButton(
                    icon: Icon(userProfileData.isFollowing
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: () {
                      FollowUpdateFlow(widget.loggedInUserId,
                          finalClickedUserId, userProfileData.isFollowing);
                    },
                  ),
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
                                getRelevantText(
                                    userProfileData.userProfile, index),
                            style: TextStyle(fontSize: 17, color: font),
                          ),
                        ),
                      );
                    },
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
    bool updatedfollowing =
        await UserProfile.FollowingExists(loggedInUserId, finalClickedUserId);
    setState(() {
      //ClickedUser = UserProfile.fetchCurrentUser(finalClickedUserId);
      isFollowing = Future.value(updatedfollowing);
    });
  }

  void Follow(int loggedInUserId, int finalClickedUserId) async {
    UserProfile.FollowUser(loggedInUserId, finalClickedUserId);
    bool updatedfollowing =
        await UserProfile.FollowingExists(loggedInUserId, finalClickedUserId);
    setState(() {
      //ClickedUser = UserProfile.fetchCurrentUser(finalClickedUserId);
      isFollowing = Future.value(updatedfollowing);
    });
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

  Future<bool> checkFollowing(
      int loggedInUserId, int finalClickedUserId) async {
    bool exists =
        await UserProfile.FollowingExists(loggedInUserId, finalClickedUserId);
    return exists;
  }

  Future<UserProfileData> fetchData() async {
    final userProfile = await UserProfile.fetchCurrentUser(finalClickedUserId);
    final followStatus =
        await checkFollowing(widget.loggedInUserId, finalClickedUserId);
    return UserProfileData(userProfile: userProfile, isFollowing: followStatus);
  }
}

class UserProfileData {
  final UserProfile userProfile;
  final bool isFollowing;

  UserProfileData({required this.userProfile, required this.isFollowing});
}
