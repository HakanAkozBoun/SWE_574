import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';


String name = "Enes Engel";
String mail = "en esengel@gmail.com";
String description = "Hiç yemek yapmadım";

// ignore: must_be_immutable
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
