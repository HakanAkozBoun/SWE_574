import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/screen/addPost.dart';
import 'package:recipe/screen/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchData(data) async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/api/blogs/?' + data));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from API');
  }
}

Future<dynamic> nutrition(blog) async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2:8000/api/Nutrition/?blog=' + blog));
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
  Map<String, dynamic> fetchedData = {};
  Map<String, dynamic> nutritionData = {};
  int avg_rating = 5;

  @override
  void initState() {
    super.initState();
    fetchData(widget.slug).then((data) {
      setState(() {
        var selectedItem =
            data.where((item) => item['id'] == widget.id).toList().first;
        fetchedData = selectedItem.cast<String, dynamic>();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: fetchedData["image"] != null
                    ? Image.network(
                        fetchedData["image"],
                        fit: BoxFit.cover,
                        scale: 2,
                      )
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
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                    radius: 18,
                    child: Icon(
                      Icons.favorite_border,
                      size: 25,
                      color: font,
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
    int say = int.parse(fetchedData["avg_rating"] ?? "5");
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    for (int i = 0; i < say; i++)
                      Icon(
                        Icons.star,
                        color: say >= i + 1 ? Colors.yellow : Colors.grey,
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
                      "Cooking Time : " + fetchedData["cookingtime"],
                      style: TextStyle(
                        fontSize: 16,
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
                      "Serving : " + fetchedData["serving"],
                      style: TextStyle(
                        fontSize: 16,
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
                      "Preparation Time : " + fetchedData["preparationtime"],
                      style: TextStyle(
                        fontSize: 16,
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
              SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  fetchedData["contentTwo"] ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: font,
                    fontFamily: 'ro',
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
                                    title: Text('${entry.key}: ${entry.value}'),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      fontFamily: 'ro',
                      fontWeight: FontWeight.w500,
                    )),
              ),
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
                  child: Text('Draft'),
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
