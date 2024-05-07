import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/models/userProfile.dart';
import 'package:recipe/widgets/home/PersonalPage.dart';
import 'package:recipe/widgets/home/app_drawer.dart';
import 'package:recipe/widgets/home/appbar2.dart';
import 'package:recipe/widgets/home/faqs.dart';
import 'package:recipe/widgets/home/logout.dart';
import 'package:recipe/widgets/home/personal.dart';
import 'package:recipe/widgets/home/nutritionalProfile.dart';
import 'package:recipe/widgets/home/myRecipes.dart';
import 'package:recipe/widgets/home/following.dart';
import 'package:recipe/widgets/home/bookmarked.dart';
import 'package:recipe/widgets/home/settings.dart';
import 'dart:async';
import 'allergy.dart';

//fotograf secme ozellıgı eklenebilir

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  final int? userId; // Make userId nullable

  Profile({this.userId, Key? key}) : super(key: key);
  //Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<UserProfile> currentUser;
  late int finalUserId;

  @override
  void initState() {
    super.initState();
    //EE

    finalUserId = widget.userId ?? 1;
    currentUser = UserProfile.fetchCurrentUser(finalUserId);
  }

  List<Icon> allIcons = [
    Icon(Icons.work, color: maincolor),
    Icon(Icons.restaurant, color: maincolor),
    Icon(Icons.school, color: maincolor),
    Icon(Icons.person, color: maincolor),
    Icon(Icons.group, color: maincolor),
    Icon(Icons.thumb_up, color: maincolor),
    Icon(Icons.fitness_center, color: maincolor),
    Icon(Icons.edit_document, color: maincolor),
    Icon(Icons.settings, color: maincolor),
    Icon(Icons.settings, color: maincolor),
    Icon(Icons.chat, color: maincolor),
    Icon(Icons.login, color: maincolor),
  ];
  List allTileNames = [
    'Working at: ',
    'Cuisines of expertise: ',
    'Graduated from: ',
    'Personal',
    'Following',
    'Bookmarked',
    'Nutritional Profile',
    'My Recipes',
    'My Allergies',
    'Settings',
    'FAQs',
    'Logout'
  ];

  void _showAllSubPages(
      BuildContext context, int index, UserProfile currentUser) {
    Widget toBeOpened = FAQs();
    Widget personal = PersonalPage(userId: finalUserId);
    Widget following = Following(userId: finalUserId);
    Widget bookmarked = Bookmarked(userId: finalUserId);
    Widget nutritionalProfile = NutritionalProfile();
    Widget myRecipes = MyRecipes(userId: finalUserId);
    Widget myAllergies = AllergyPage(userId: finalUserId);
    Widget settings = Settings();
    Widget faqs = FAQs();
    Widget logout = Logout();
    bool isFullPage = false;
    switch (index) {
      case 0:
        isFullPage = false;
        break;
      case 1:
        isFullPage = false;
        break;
      case 2:
        isFullPage = false;
        break;
      case 3:
        toBeOpened = personal;
        isFullPage = true;
        break;
      case 4:
        toBeOpened = following;
        isFullPage = true;
        break;
      case 5:
        toBeOpened = bookmarked;
        isFullPage = true;
        break;
      case 6:
        toBeOpened = nutritionalProfile;
        isFullPage = true;
        break;
      case 7:
        toBeOpened = myRecipes;
        isFullPage = true;
        break;
      case 8:
        toBeOpened = myAllergies;
        isFullPage = true;
        break;
      case 9:
        toBeOpened = settings;
        isFullPage = true;
        break;
      case 10:
        toBeOpened = faqs;
        isFullPage = false;
        break;
      case 11:
        toBeOpened = logout;
        isFullPage = false;
        break;
      default:
        isFullPage = false; //belki throw exception yapılabilir
    }
    if (isFullPage) {
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => toBeOpened,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ));
    } else {
      if (index < 3) {
        String givenText = getRelevantText(currentUser, index);
        _showSubPage(context, givenText, index);
      } else {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return toBeOpened;
            });
      }
    }

    //TextEditingController textEditingController =
    //  TextEditingController(text: index.toString());
  }

  void _showSubPage(BuildContext context, givenText, index) {
    TextEditingController textEditingController =
        TextEditingController(text: givenText);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.5, // ekranın tamamını kaplamasın diye
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: allTileNames[index],
                  ),
                  autofocus: true,
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
                      UpdateShownInfo(textEditingController.text, index);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar2(),
        drawer: appDrawer(),
        backgroundColor: background,
        body: SafeArea(
            child: FutureBuilder<UserProfile>(
          future: currentUser,
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
              UserProfile currentUser = snapshot.data!;
              return Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(currentUser.image),
                  ),
                  SizedBox(height: 10),
                  Text(
                    currentUser.user.username,
                    style:
                        TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
                  ),
                  Text(
                    currentUser.description,
                    style:
                        TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
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
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 12,
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
                                  getRelevantText(currentUser, index),
                              style: TextStyle(fontSize: 17, color: font),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: () =>
                                _showAllSubPages(context, index, currentUser),
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

  UpdateShownInfo(String text, int index) async {
    String field = "";
    switch (index) {
      case 0:
        field = "working_at";
        break;
      case 1:
        field = "cuisines_of_expertise";
        break;
      case 2:
        field = "graduated_from";
        break;
      default:
        field = "";
    }
    var myMap = Map<String, String>();
    myMap[field] = text;
    UserProfile updatedProfile =
        await UserProfile.updateUserProfile(finalUserId, myMap);
    setState(() {
      currentUser = Future.value(updatedProfile);
    });
    Navigator.pop(context);
  }
}
