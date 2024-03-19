import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:url_launcher/url_launcher.dart';

String name = "Enes Engel";
String mail = "enesengel@gmail.com";
String description = "Hiç yemek yapmadım";
String photoPath = "images/Enes.jpg";

//fotograf secme ozellıgı eklenebilir
class FAQs extends StatelessWidget {
  final Uri _url = Uri.parse('https://www.cookpad.com/faq');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.5, // ekranın tamamını kaplamasın diye
      child: Center(
        child: ElevatedButton(
          onPressed: _launchUrl,
          child: Text('FREQUENTLY ASKED QUESTIONS'),
        ),
      ),
    );
  }
}

class Personal extends StatelessWidget {
  List personalTileInfo = [name, mail, description];
  List personalTileNames = ['Name', 'E-mail', 'Description'];

  void EditPersonalInfo(BuildContext context, int index) {
    TextEditingController chosenTextEditingController;
    switch (index) {
      case 0:
        chosenTextEditingController = TextEditingController(text: name);
        break;
      case 1:
        chosenTextEditingController = TextEditingController(text: mail);
        break;
      case 2:
        chosenTextEditingController = TextEditingController(text: description);
        break;
      default: //burası degisebilir
        chosenTextEditingController = TextEditingController(text: name);
    }
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
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
              personalTileInfo[index],
              style: TextStyle(fontSize: 17, color: font),
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => EditPersonalInfo(context, index),
          ),
        );
      },
    );
  }
}

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.5, // ekranın tamamını kaplamasın diye
      child: Column(
        children: [
          SizedBox(height: 50),
          Center(
            child: Text(
              "Are you sure you want to log out?",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: font, fontFamily: 'ro'),
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
  }
}

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
    Icon(Icons.settings, color: maincolor),
    Icon(Icons.chat, color: maincolor),
    Icon(Icons.login, color: maincolor),
  ];
  List tileNames = [
    'Working at: ',
    'Cuisines of expertise: ',
    'Graduated from: ',
  ];
  List constTileNames = ['Personal', 'Settings', 'FAQs', 'Logout'];
  void _showStableSubPage(BuildContext context, int index) {
    Widget toBeOpened = FAQs();
    switch (index) {
      case 0: //Personal
        toBeOpened = Personal();
        break;
      case 1: //Settings
        break;
      case 2: //FAQs
        toBeOpened = FAQs();

        break;
      case 3: //Logout
        toBeOpened = Logout();
        break;
      default: //belki throw exception yapılabilir
    }
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return toBeOpened;
        });
    TextEditingController textEditingController =
        TextEditingController(text: index.toString());
    /* showModalBottomSheet(
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
                labelText: constTileNames[index],
              ),
              autofocus: true,
              //child: Text( tileName),
            ),
          ),
        );
      },
    );*/
  }

  void _showSubPage(BuildContext context, int index) {
    TextEditingController textEditingController =
        TextEditingController(text: tileNames[index]);
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
            'hiç yemek yapmadım',
            style: TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 40,
              thickness: 2,
            ),
          ),
          ListView.builder(
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
                    tileNames[index],
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
          ListView.builder(
            // sabit kalacak son 4
            shrinkWrap: true,
            itemCount: 4,
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
        ],
      )),
    );
  }
}
