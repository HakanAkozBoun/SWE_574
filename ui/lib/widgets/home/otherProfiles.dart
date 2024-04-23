import 'package:flutter/material.dart';
import 'package:recipe/widgets/home/testUser.dart';
import 'package:recipe/models/userProfile.dart';

String photoPath = "./images/dinner0.jpg";

class OtherProfiles extends StatelessWidget {
  final UserProfile user;

  OtherProfiles({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.user.username),
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  AssetImage(user.image), //buraya image ekleyeceğim
            ),
            //Image.network(photoPath),//burası değişecek
            Text(user.user.username),
            Text(user.description),
          ],
        ),
      ),
    );
  }
}
