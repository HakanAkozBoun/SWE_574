import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/helpers/userData.dart';
import 'package:recipe/screen/addPost.dart';
import 'package:recipe/screen/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:recipe/widgets/home/app_drawer.dart';
import 'package:recipe/widgets/home/appbar2.dart';
import 'package:recipe/constants/backend_url.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe/widgets/home/otherProfiles.dart';

const String uri = BackendUrl.apiUrl;

Future<List<dynamic>> fetchData(data) async {
  final response =
      await http.get(Uri.parse(uri + 'PopularPostsApiView/?' + data));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from API');
  }
}

Future<dynamic> nutrition(blog) async {
  final response = await http.get(Uri.parse(uri + 'Nutrition/?blog=' + blog));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from API');
  }
}

Future<dynamic> userlist() async {
  final response = await http.get(Uri.parse(uri + 'UserList/'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from API');
  }
}

class Recipe extends StatefulWidget {
  const Recipe({Key? key, String? this.slug, required var this.id})
      : super(key: key);
  final String? slug;
  final id;
  @override
  State<Recipe> createState() => _Recipe();
}

class _Recipe extends State<Recipe> {
  UserData user = UserData();
  var userId;
  var userName;
  bool isBookmarked = false;
  bool isEaten = false;
  int serving = 1;

  Map<String, dynamic> fetchedData = {};
  Map<String, dynamic> nutritionData = {};
  Map<String, dynamic> userData = {};

  // int avg_rating = 5;

  List<Yorum> yorumlar = [];
  String yeniYorum = '';

  int selectedRating = 0;

  void _selectRating(int rating) {
    setState(() {
      selectedRating = rating;
    });
  }

  void _sendRating() async {
    final response = await http.get(
      Uri.parse(uri +
          'add_rating/?user_id=' +
          user.getUserId().toString() +
          '&recipe_id=' +
          fetchedData["id"].toString() +
          '&value=' +
          selectedRating.toString()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Thank you for your rating',
              style: TextStyle(color: Colors.white)),
        ),
      );
      print('Rating sent successfully');
    } else {
      print('Error sending rating: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    userId = user.getUserId();
    // userName = user.getUserName();
    yorumlariYukle();

    fetchData(widget.slug).then((data) {
      setState(() {
        var selectedItem =
            data.where((item) => item['id'] == widget.id).toList().first;
        fetchedData = selectedItem.cast<String, dynamic>();
        userlist().then((data) {
          setState(() {
            var selectedItem = data
                .where((item) => item['id'] == fetchedData["userid"])
                .toList()
                .first;
            userData = selectedItem.cast<String, dynamic>();
          });
        }).catchError((error) {
          print("Error fetching data: $error");
        });
      });
    }).catchError((error) {
      print("Error fetching data: $error");
    });
    nutrition(widget.id.toString()).then((data) {
      setState(() {
        nutritionData = data;
      });
    }).catchError((error) {
      print("Error fetching data: $error");
    });

    checkBookmarkStatus(userId.toString(), widget.id.toString());
    checkEatenStatus(userId.toString(), widget.id.toString());
    super.initState();
  }

  void yorumlariYukle() async {
    // API'den yorumları alın ve yorumlar listesine ekleyin

    var response = await http
        .get(Uri.parse(uri + 'CommentList/?blog=' + widget.id.toString()));
    if (response.statusCode == 200) {
      setState(() {
        yorumlar = (jsonDecode(response.body) as List)
            .map((yorumData) => Yorum(
                text: yorumData["text"].toString(),
                blog: yorumData["id"],
                user: yorumData["name"].toString()))
            .toList();
      });
    } else {
      // Hata mesajı gösterin
    }
  }

  Map<String, dynamic> dataList = {};
  void yeniYorumGonder() async {
    // Yeni yorumu API'ye gönderin
    dataList = {
      "user": userId,
      "blog": widget.id,
      "text": yeniYorum.toString()
    };
    var response = await http.post(Uri.parse(uri + 'CreateComment/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dataList));
    if (response.statusCode == 200) {
      setState(() {
        yorumlar.add(Yorum(
            text: yeniYorum.toString(), blog: widget.id, user: 'Hakan Aköz'));
        yeniYorum = '';
      });
    } else {
      // Hata mesajı gösterin
    }
  }

  void toggleUserBookmark(String userId, String blogId) async {
    String url = uri + "bookmark/?user_id=$userId&blog_id=$blogId";
    await http.get(Uri.parse(url)).then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['is_bookmarked'] == true) {
        setState(() {
          isBookmarked = true;
        });
      } else if (jsonResponse['is_bookmarked'] == false) {
        setState(() {
          isBookmarked = false;
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void checkBookmarkStatus(String userId, String blogId) async {
    String url = uri + "bookmark-exist/?user_id=$userId&blog_id=$blogId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        isBookmarked = jsonResponse['is_bookmarked'];
      });
    } else {
      print("Failed to load bookmark status: ${response.statusCode}");
    }
  }

  void toggleEaten(String userId, String blogId, String serving) async {
    String url =
        uri + "eaten/?user_id=$userId&blog_id=$blogId&serving=$serving";
    await http.get(Uri.parse(url)).then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['is_eaten'] == true) {
        setState(() {
          isEaten = true;
        });
      } else if (jsonResponse['is_eaten'] == false) {
        setState(() {
          isEaten = false;
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void checkEatenStatus(String userId, String blogId) async {
    String url = uri + "eaten-exist/?user_id=$userId&blog_id=$blogId";
    await http.get(Uri.parse(url)).then((response) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['is_eaten'] == true) {
        setState(() {
          isEaten = true;
          serving = jsonResponse['serving'];
        });
      } else if (jsonResponse['is_eaten'] == false) {
        setState(() {
          isEaten = false;
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    var url = fetchedData['base64'] ?? "";
    Uint8List decodedImage = base64Decode(url);
    return Scaffold(
      appBar: AppBar2(),
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: fetchedData["base64"] != null
                    ? Image.memory(decodedImage)
                    : Image.asset(
                        'images/lunch1.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        width: 80,
                        height: 4,
                        color: font,
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      toggleUserBookmark(
                          userId.toString(), widget.id.toString());
                    },
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                      radius: 18,
                      child: Icon(
                        isBookmarked ? Icons.favorite : Icons.favorite_border,
                        size: 25,
                        color: font,
                      ),
                    ),
                  ),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                  radius: 18,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Home();
                          },
                        ),
                      );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: font,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _getbody(),
            )
          ],
        ),
      ),
    );
  }

  Widget _getbody() {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherProfiles(
                            loggedInUserId: userId,
                            clickedUserId: fetchedData["userid"]),
                      ),
                    );
                  },
                  child: Text("By Chef " + userData["username"].toString(),
                      textAlign: TextAlign.end),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (int i = 1; i <= 5; i++)
                              GestureDetector(
                                onTap: () => _selectRating(i),
                                child: Icon(
                                  i <= selectedRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 40,
                                  color: Colors.yellow,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _sendRating,
                          child: Text('Send Rate'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: GestureDetector(
                      onTap: () {
                        // toggleEaten("23", widget.id.toString(), "1");
                        toggleEaten(userId.toString(), widget.id.toString(),
                            serving.toString());
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                            radius: 18,
                            child: isEaten
                                ? SvgPicture.asset(
                                    "icons/eat.svg",
                                    width: 50,
                                    height: 50,
                                  )
                                : SvgPicture.asset(
                                    "icons/noteat.svg",
                                    width: 50,
                                    height: 50,
                                  ),
                          ),
                          SizedBox(
                              height:
                                  8), // Adjust as needed for spacing between icon and text
                          Text(
                            isEaten ? "Eaten" : "Not Eaten",
                            style: TextStyle(
                              fontSize: 14, // Adjust as needed for text size
                              color: Colors
                                  .black, // Adjust as needed for text color
                            ),
                          ),
                          if (isEaten) ...[
                            DropdownButton<int>(
                              value: serving,
                              onChanged: (int? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    toggleEaten(
                                        userId.toString(),
                                        widget.id.toString(),
                                        newValue.toString());
                                    serving = newValue;
                                  });
                                }
                              },
                              items: [1, 2, 3, 4, 5]
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "Cooking Time : " +
                          fetchedData["cookingtime"].toString() +
                          " min",
                      style: TextStyle(
                        fontSize: 16,
                        color: font,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'ra',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "Rating : " +
                          fetchedData["avg_rating"].toString() +
                          " star",
                      style: TextStyle(
                        fontSize: 16,
                        color: font,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'ra',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "Serving : " + fetchedData["serving"].toString() + " min",
                      style: TextStyle(
                        fontSize: 16,
                        color: font,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'ra',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "Preparation Time : " +
                          fetchedData["preparationtime"].toString() +
                          " min",
                      style: TextStyle(
                        fontSize: 16,
                        color: font,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'ra',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      fetchedData["title"] ?? "",
                      style: TextStyle(
                        fontSize: 24,
                        color: font,
                        fontFamily: 'ro',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 20,
                        color: font,
                        fontFamily: 'ro',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  fetchedData["contentTwo"] ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: font,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'ra',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      'Nutritions',
                      style: TextStyle(
                        fontSize: 20,
                        color: font,
                        fontFamily: 'ro',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          children: nutritionData.entries
                              .where((entry) =>
                                  entry.key != "blogid" && entry.key != "blog")
                              .map((entry) => ListTile(
                                    title: Text(
                                        '${entry.key}: ${entry.value.round()} ${entry.key == "calorie" ? "kcal" : entry.key == "vitamina" ? "UI" : "g"}'),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 20,
                        color: font,
                        fontFamily: 'ro',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  fetchedData["ingredients"] ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: font,
                    fontFamily: 'ra',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      'Recipe',
                      style: TextStyle(
                        fontSize: 20,
                        color: font,
                        fontFamily: 'ro',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(fetchedData["content"] ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: font,
                      fontFamily: 'ra',
                      fontWeight: FontWeight.w400,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 20,
                        color: font,
                        fontFamily: 'ro',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: yorumlar.length,
                itemBuilder: (context, index) {
                  var yorum = yorumlar[index];
                  return ListTile(
                    title: Text(yorum.text),
                    subtitle: Text(yorum.user),
                  );
                },
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Yorumunuzu girin'),
                      onChanged: (value) {
                        setState(() {
                          yeniYorum = value;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      yeniYorumGonder();
                    },
                    child: Text('Gönder'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AddItemPage(
                          edit: 1, item: fetchedData, id: widget.id),
                    ));
                  },
                  child: Text('Edit'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AddItemPage(
                          edit: 2, item: fetchedData, id: widget.id),
                    ));
                  },
                  child: Text('Derive'),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class Yorum {
  String text;
  String user;
  int blog;

  Yorum({required this.text, required this.user, required this.blog});

  factory Yorum.fromJson(Map<String, dynamic> json) {
    return Yorum(text: json['yorum'], user: json['yazar'], blog: json['blog']);
  }
}
