import 'package:flutter/material.dart';
import 'package:recipe/widgets/home/testUser.dart';
String photoPath = "./images/dinner0.jpg";

class OtherProfiles extends StatelessWidget {
  final TestUser user;

  OtherProfiles({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
      ),
      body: Center(
        child: Column(
           
          children: [
            CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage(photoPath), //buraya image ekleyeceğim
                  ),
            //Image.network(photoPath),//burası değişecek
            Text(user.username),
            Text(user.description),
          ],
        ),
      ),
    );
  }
}
