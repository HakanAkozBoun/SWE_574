import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/models/userProfile.dart';
import 'package:recipe/widgets/home/app_drawer.dart';
import 'package:recipe/widgets/home/appbar2.dart';

// ignore: must_be_immutable
class PersonalPage extends StatefulWidget {
  final int userId;

  PersonalPage({required this.userId, Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late Future<UserProfile> currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = UserProfile.fetchCurrentUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar2(),
        drawer: AppDrawer(),
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
                  Flexible(
                    child: InfoList(context, currentUser),
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

  Widget InfoList(BuildContext context, UserProfile givenUser) {
    return SingleChildScrollView(
      child: Column(
        children: [
          userNameTile(givenUser.user.username, 0),
          emailTile(givenUser.user.email, 1),
          descriptionTile(givenUser.description, 2),
          ageTile(givenUser.age, 3),
          weightTile(givenUser.weight, 4),
          heightTile(givenUser.height, 5),
          experienceTile(givenUser.experience, 6),
          genderTile(givenUser.gender, 7)
        ],
      ),
    );
  }

  ListTile userNameTile(String username, int index) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Username: ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            username,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showSubPage(context, username, 'Username: ', index);
        },
      ),
    );
  }

  ListTile emailTile(String email, int index) {
    return ListTile(
      leading: Icon(Icons.email),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'E-mail: ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showSubPage(context, email, 'E-mail: ', index);
        },
      ),
    );
  }

  ListTile descriptionTile(String description, int index) {
    return ListTile(
      leading: Icon(Icons.description),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Description: ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showSubPage(context, description, 'Description: ', index);
        },
      ),
    );
  }

  ListTile ageTile(int age, int index) {
    return ListTile(
      leading: Icon(Icons.cake),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Age: ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            age.toString(),
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showSubPage(context, age.toString(), 'Age: ', index);
        },
      ),
    );
  }

  ListTile weightTile(double weight, int index) {
    return ListTile(
      leading: Icon(Icons.line_weight),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Weight(kg): ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            weight.toString(),
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showSubPage(context, weight.toString(), 'Weight(kg): ', index);
        },
      ),
    );
  }

  ListTile heightTile(double height, int index) {
    return ListTile(
      leading: Icon(Icons.height),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Height(cm): ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            height.toString(),
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showSubPage(context, height.toString(), 'Height(cm): ', index);
        },
      ),
    );
  }

  ListTile experienceTile(int experience, int index) {
    return ListTile(
      leading: Icon(Icons.star),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Experience: ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            experience.toString(),
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showSubPage(context, experience.toString(), 'Experience: ', index);
        },
      ),
    );
  }

  ListTile genderTile(String gender, int index) {
    return ListTile(
      leading: Icon(Icons.wc),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Gender: ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            gender.toString(),
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _showSubPageForGender(
                context, gender.toString(), 'Gender: ', index);
          }),
    );
  }

  bool ValidateUpdate(String text, int index) {
    switch (index) {
      case 0:
        return ValidateUsername(text);
      case 1:
        return ValidateEmail(text);
      case 2:
        return ValidateDescription(text);
      case 3:
        return ValidateAge(text);
      case 4:
        return ValidateWeight(text);
      case 5:
        return ValidateHeight(text);
      case 6:
        return ValidateExperience(text);
      case 7:
        return ValidateGender(text);
      default:
        return false;
    }
  }

  bool ValidateUsername(String username) {
    username = username.trim();
    final pattern = RegExp(r'^[a-zA-Z0-9@.+/_-]+$');

    if (username.length <= 150 && pattern.hasMatch(username)) {
      return true;
    }
    showAlertDialog(context,
        "Username must be 150 characters or fewer. Letters, digits and @/./+/-/_ only.");
    return false;
  }

  Future<bool> checkUsernameAvailability(String username) async {
    bool available = await UserProfile.UsernameExists(widget.userId, username);
    return !available;
  }

  Future<bool> checkEmailAvailability(String email) async {
    bool available = await UserProfile.EmailExists(widget.userId, email);
    return !available;
  }

  bool ValidateEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    if (emailRegex.hasMatch(email)) {
      return true;
    }

    showAlertDialog(context, "This email format is not acceptable.");
    return false;
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invalid Input"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  bool ValidateDescription(String description) {
    String errorMessage = "Description must be less than 255 characters.";
    if (description.length > 255) {
      showAlertDialog(context, errorMessage);
      return false;
    }
    return true;
  }

  bool ValidateAge(String ageStr) {
    int? age = int.tryParse(ageStr);
    String errorMessage = "Age must be an integer.";
    if (age == null) {
      showAlertDialog(context, errorMessage);
      return false;
    }
    return true;
  }

  bool ValidateWeight(String weightStr) {
    double? weight = double.tryParse(weightStr);
    String errorMessage = "Weight must be a number.";
    if (weight == null) {
      showAlertDialog(context, errorMessage);
      return false;
    }
    return true;
  }

  bool ValidateHeight(String heightStr) {
    double? height = double.tryParse(heightStr);
    String errorMessage = "Height must be a number.";
    if (height == null) {
      showAlertDialog(context, errorMessage);
      return false;
    }
    return true;
  }

  bool ValidateExperience(String experienceStr) {
    int? experience = int.tryParse(experienceStr);
    String errorMessage = "Experience must be an integer.";
    if (experience == null) {
      showAlertDialog(context, errorMessage);
      return false;
    }
    return true;
  }

  bool ValidateGender(String gender) {
    List<String> genders = ['M', 'm', 'F', 'f'];
    String errorMessage = "Gender can be either M or F.";

    if (genders.contains(gender))
      return true;
    else {
      showAlertDialog(context, errorMessage);
      return false;
    }
  }

  void ArrangeUpdate(String text, int index) {
    switch (index) {
      case 0:
        UpdateUsername(text);
        break;
      case 1:
        UpdateEmail(text);
        break;
      case 2:
        UpdateDescription(text);
        break;
      case 3:
        UpdateAge(text);
        break;
      case 4:
        UpdateWeight(text);
        break;
      case 5:
        UpdateHeight(text);
        break;
      case 6:
        UpdateExperience(text);
        break;
      case 7:
        UpdateGender(text);
        break;
    }
  }

  void UpdateUsername(String username) async {
    username = username.trim();
    bool available = await checkUsernameAvailability(username);
    if (available) {
      var myMap = Map<String, dynamic>();
      myMap['username'] = username;
      UserProfile updatedProfile =
          await UserProfile.updateUser(widget.userId, myMap);
      setState(() {
        currentUser = Future.value(updatedProfile);
      });
    } else {
      showAlertDialog(context, "Username is already taken.");
    }
  }

  void UpdateEmail(String email) async {
    email = email.trim();
    bool available = await checkEmailAvailability(email);
    if (available) {
      var myMap = Map<String, dynamic>();
      myMap['email'] = email;
      UserProfile updatedProfile =
          await UserProfile.updateUser(widget.userId, myMap);
      setState(() {
        currentUser = Future.value(updatedProfile);
      });
    } else {
      showAlertDialog(context, "This Email is already taken.");
    }
  }

  void UpdateDescription(String description) async {
    description = description.trim();
    var myMap = Map<String, dynamic>();
    myMap['description'] = description;
    UserProfile updatedProfile =
        await UserProfile.updateUserProfile(widget.userId, myMap);
    setState(() {
      currentUser = Future.value(updatedProfile);
    });
  }

  void UpdateAge(String ageStr) async {
    ageStr = ageStr.trim();
    int age = int.parse(ageStr);
    var myMap = Map<String, dynamic>();
    myMap['age'] = age;
    UserProfile updatedProfile =
        await UserProfile.updateUserProfile(widget.userId, myMap);
    setState(() {
      currentUser = Future.value(updatedProfile);
    });
  }

  void UpdateWeight(String weightStr) async {
    weightStr = weightStr.trim();
    double weight = double.parse(weightStr);
    var myMap = Map<String, dynamic>();
    myMap['weight'] = weight;
    UserProfile updatedProfile =
        await UserProfile.updateUserProfile(widget.userId, myMap);
    setState(() {
      currentUser = Future.value(updatedProfile);
    });
  }

  void UpdateHeight(String heightStr) async {
    heightStr = heightStr.trim();
    double height = double.parse(heightStr);
    var myMap = Map<String, dynamic>();
    myMap['height'] = height;
    UserProfile updatedProfile =
        await UserProfile.updateUserProfile(widget.userId, myMap);
    setState(() {
      currentUser = Future.value(updatedProfile);
    });
  }

  void UpdateExperience(String experienceStr) async {
    experienceStr = experienceStr.trim();
    int experience = int.parse(experienceStr);
    var myMap = Map<String, dynamic>();
    myMap['experience'] = experience;
    UserProfile updatedProfile =
        await UserProfile.updateUserProfile(widget.userId, myMap);
    setState(() {
      currentUser = Future.value(updatedProfile);
    });
  }

  void UpdateGender(String genderStr) async {
    genderStr = genderStr.trim();
    var myMap = Map<String, dynamic>();
    myMap['gender'] = genderStr;
    UserProfile updatedProfile =
        await UserProfile.updateUserProfile(widget.userId, myMap);
    setState(() {
      currentUser = Future.value(updatedProfile);
    });
  }

  void _showSubPageForGender(
      BuildContext context, givenText, labelName, index) {
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
                    labelText: labelName,
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
                      UpdateFlow(textEditingController.text, index);
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

  void _showSubPage(BuildContext context, givenText, labelName, index) {
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
                    labelText: labelName,
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
                      UpdateFlow(textEditingController.text, index);
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

  void UpdateFlow(String text, int index) {
    text = text.trim();
    if (ValidateUpdate(text, index)) {
      ArrangeUpdate(text, index);
      Navigator.pop(context);
    } else {
      print("Invalid input");
    }
  }
}
