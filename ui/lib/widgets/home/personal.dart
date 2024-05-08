import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/models/userProfile.dart';

// ignore: must_be_immutable
class Personal extends StatefulWidget {
  final int userId;

  Personal({required this.userId, Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  late Future<UserProfile> currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = UserProfile.fetchCurrentUser(widget.userId);
  }

  List personalTileNames = [
    'Username',
    'E-mail',
    'Description',
    'age',
    'weight',
    'height',
    'image',
    'experience',
    'gender'
  ];

  String getPersonalInfo(UserProfile givenUser, int index) {
    switch (index) {
      case 0:
        return givenUser.user.username;
      case 1:
        return givenUser.user.email;
      case 2:
        return givenUser.description;
      case 3:
        return givenUser.age.toString();
      case 4:
        return givenUser.weight.toString();
      case 5:
        return givenUser.height.toString();
      case 6:
        return givenUser.image;
      case 7:
        return givenUser.experience.toString();
      case 8:
        return givenUser.gender;
      default: //burası degisebilir
        return givenUser.user.username;
    }
  }

  void EditPersonalInfo(
      BuildContext context, int index, UserProfile givenUser) {
    TextEditingController chosenTextEditingController;
    chosenTextEditingController =
        TextEditingController(text: getPersonalInfo(givenUser, index));

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
                  controller: chosenTextEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: personalTileNames[index],
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
                      //bunlar eklenmeli
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              UserProfile gotUser = snapshot.data!;
              return Flexible(child: InfoList(context, gotUser));
              /* return ListView.builder(
                shrinkWrap: true,
                itemCount: 9,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        personalTileNames[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: font),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        getPersonalInfo(gotUser, index),
                        style: TextStyle(fontSize: 17, color: font),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          EditPersonalInfo(context, index, gotUser),
                    ),
                  );
                },
              );
           */
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

  Widget InfoList(BuildContext context, UserProfile givenUser) {
    return Column(
      children: [
        personalTile(
            personalTileNames[0], givenUser.user.username, Icons.person),
        personalTile(personalTileNames[1], givenUser.user.email, Icons.email),
        personalTile(
            personalTileNames[2], givenUser.description, Icons.description),
        personalTile(
            personalTileNames[3], givenUser.age.toString(), Icons.cake),
        personalTile(personalTileNames[4], givenUser.weight.toString(),
            Icons.line_weight),
        personalTile(
            personalTileNames[5], givenUser.height.toString(), Icons.height),
        personalTile(personalTileNames[6], givenUser.image, Icons.image),
        personalTile(
            personalTileNames[7], givenUser.experience.toString(), Icons.star),
        personalTile(personalTileNames[8], givenUser.gender, Icons.wc),
      ],
    );
  }

  ListTile personalTile(String title, String presonalInfo, IconData icon) {
    return ListTile(
      leading: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: font),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          presonalInfo,
          style: TextStyle(fontSize: 17, color: font),
        ),
      ),
      trailing: IconButton(icon: Icon(Icons.edit), onPressed: () => {}),
    );
  }
}
