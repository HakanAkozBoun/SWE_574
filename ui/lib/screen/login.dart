import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/consent/navigation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController mailController = TextEditingController();
  TextEditingController usernameSingUpController = TextEditingController();
  TextEditingController passwordSingUpController = TextEditingController();

  bool isLoggedIn = false;

  Future<void> singUp() async {
    String mail = mailController.text;
    String usernameSingUp = usernameSingUpController.text;
    String passwordSingUp = passwordSingUpController.text;

    Uri apiUrl2 = Uri.parse('http://10.0.2.2:8000/api/CreateUser/');

    Map data2 = {
      'user': mail,
      'pass': passwordSingUp,
      'mail': mail,
      'first_name': usernameSingUp,
      'last_name': usernameSingUp,
    };

    // POST isteği gönder
    var response = await http.post(
      apiUrl2,
      body: jsonEncode(data2),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    // Yanıtın durumunu kontrol et
    if (response.statusCode == 200) {
      // Giriş başarılı
      print("Başarılı");
    } else {
      // Giriş başarısız
      print('Başarısız. Hata kodu: ${response.statusCode}');
    }
  }

  Future<void> login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // API endpoint
    Uri apiUrl = Uri.parse('http://10.0.2.2:8000/api/Login/');

    // Gönderilecek veri
    Map data = {
      'user': username,
      'pass': password,
    };

    // POST isteği gönder
    var response = await http.post(
      apiUrl,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    // Yanıtın durumunu kontrol et
    if (response.statusCode == 200) {
      // Giriş başarılı
      print("Başarılı");

      setState(() {
        isLoggedIn = true;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => Navigation())));
      });
    } else {
      // Giriş başarısız
      print('Giriş başarısız. Hata kodu: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 120),
            Center(
              child: Text(
                'Login',
                style: TextStyle(
                  color: font,
                  fontFamily: 'ro',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Email',
                    hintStyle: TextStyle(fontFamily: 'ro'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: passwordController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'password',
                    hintStyle: TextStyle(fontFamily: 'ro'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                login();
                //   Navigator.of(context).push(
                //       MaterialPageRoute(builder: ((context) => Navigation())));
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 160,
                decoration: BoxDecoration(
                  color: maincolor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'ro',
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 180),
            Expanded(
              child: GestureDetector(
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(1, 1),
                        blurRadius: 20,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(120),
                      topRight: Radius.circular(120),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontFamily: 'ro',
                        color: font,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.77,
                        builder: (context, scrollController) {
                          return Container(
                            decoration: BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(120),
                                topRight: Radius.circular(120),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 50),
                                Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontFamily: 'ro',
                                    color: font,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 40),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      controller: mailController,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.email),
                                        hintText: 'Email',
                                        hintStyle: TextStyle(fontFamily: 'ro'),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      controller: usernameSingUpController,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.person),
                                        hintText: 'User Name',
                                        hintStyle: TextStyle(fontFamily: 'ro'),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      obscureText: true,
                                      obscuringCharacter: '*',
                                      controller: passwordSingUpController,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.lock),
                                        hintText: 'password',
                                        hintStyle: TextStyle(fontFamily: 'ro'),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                GestureDetector(
                                  onTap: () {
                                    singUp();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      color: maincolor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'ro',
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
