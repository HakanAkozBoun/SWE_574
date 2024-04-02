import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/widgets/home/faqs.dart';
import 'package:recipe/widgets/home/logout.dart';
import 'package:recipe/widgets/home/personal.dart';
import 'package:recipe/widgets/home/nutritionalProfile.dart';
import 'package:recipe/widgets/home/myRecipes.dart';
import 'package:recipe/widgets/home/following.dart';
import 'package:recipe/widgets/home/liked.dart';
import 'package:recipe/widgets/home/settings.dart';

String photoPath = "images/dinner1.jpg";

//fotograf secme ozellıgı eklenebilir

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  Profile({super.key});

  @override
  List<Icon> icons = [
    Icon(Icons.work, color: maincolor),
    Icon(Icons.restaurant, color: maincolor),
    Icon(Icons.school, color: maincolor),
  ];
  List<Icon> constIcons = [
    Icon(Icons.person, color: maincolor),
    Icon(Icons.group, color: maincolor),
    Icon(Icons.thumb_up, color: maincolor),
    Icon(Icons.fitness_center, color: maincolor),
    Icon(Icons.edit_document, color: maincolor),
    Icon(Icons.settings, color: maincolor),
    Icon(Icons.chat, color: maincolor),
    Icon(Icons.login, color: maincolor),
  ];
  List tileNames = [
    'Working at: ',
    'Cuisines of expertise: ',
    'Graduated from: ',
  ];
  List tileNamesInfo = [
    'Özkardeşler kebap salonu',
    'kebap',
    'Bahçeşehir Üniversitesi Gastronomi bölümü',
  ];
  List constTileNames = [
    'Personal',
    'Following',
    'Liked',
    'Nutritional Profile',
    'My Recipes',
    'Settings',
    'FAQs',
    'Logout'
  ];

  void _showStableSubPage(BuildContext context, int index) {
    Widget toBeOpened = FAQs();
    Widget personal = Personal();
    Widget following = Following();
    Widget liked = Liked();
    Widget nutritionalProfile = NutritionalProfile();
    Widget myRecipes = MyRecipes();
    Widget settings = Settings();
    Widget faqs = FAQs();
    Widget logout = Logout();
    bool isFullPage = false;
    switch (index) {
      case 0:
        toBeOpened = personal;
        isFullPage = false;
        break;
      case 1:
        toBeOpened = following;
        isFullPage = true;
        break;
      case 2:
        toBeOpened = liked;
        isFullPage = false;
        break;
      case 3:
        toBeOpened = nutritionalProfile;
        isFullPage = true;
        break;
      case 4:
        toBeOpened = myRecipes;
        isFullPage = true;
        break;
      case 5:
        toBeOpened = settings;
        isFullPage = true;
        break;
      case 6:
        toBeOpened = faqs;
        isFullPage = false;
        break;
      case 7:
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
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return toBeOpened;
          });
    }

    //TextEditingController textEditingController =
    //  TextEditingController(text: index.toString());
  }

  void _showSubPage(BuildContext context, int index) {
    TextEditingController textEditingController =
        TextEditingController(text: tileNamesInfo[index]);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.5, // ekranın tamamını kaplamasın diye
          child: Center(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: tileNames[index],
              ),
              autofocus: true,
              //child: Text( tileName),
            ),
          ),
        );
      },
    );
  }

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
                    backgroundImage:
                        AssetImage(photoPath), //buraya image ekleyeceğim
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Enes Engel',
            style: TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
          ),
          Text(
            "20 yıldır ocakbaşındayım, Adana ve İstanbul'da çalıştım",
            style: TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 40,
              thickness: 2,
            ),
          ),
          Flexible(
            child: ListView.builder(
              // degisken ilk 3
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
                    child: icons[index],
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      tileNames[index] + tileNamesInfo[index],
                      style: TextStyle(fontSize: 17, color: font),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () => _showSubPage(context, index),
                  ),
                );
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
              // sabit kalacak son 8
              shrinkWrap: true,
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Container(
                    width: 37,
                    height: 37,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: constIcons[index],
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      constTileNames[index],
                      style: TextStyle(fontSize: 17, color: font),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () => _showStableSubPage(context, index),
                  ),
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
