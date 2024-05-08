import 'package:flutter/material.dart';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/screen/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:recipe/constants/backend_url.dart';
import 'package:recipe/widgets/home/app_drawer.dart';
import 'package:recipe/widgets/home/appbar2.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

Future<List<dynamic>> fetchData() async {
  const String popularRecipes = BackendUrl.apiUrl + 'PopularPostsApiView/';
  final response = await http
      .get(Uri.parse(popularRecipes));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from API');
  }
}

class _HomeState extends State<Home> {
  var indexx = 0;
  List? fetchedData;

  @override
  void initState() {
    super.initState();
    fetchData().then((data) {
      setState(() {
        print(data);
        fetchedData = data;
      });
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar2(),
      drawer: AppDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (fetchedData != null) {
                    // Eğer veri varsa fetchedData'yı kullan
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Recipe(
                              slug: fetchedData![index]["slug"],
                              id: fetchedData![index]["id"]),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 185, 185, 185),
                              offset: Offset(1, 1),
                              blurRadius: 15,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'http://10.0.2.2:8000' +
                                          fetchedData![index]['image'] +
                                          '',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              fetchedData![index]['title'],
                              style: TextStyle(
                                fontSize: 18,
                                color: font,
                                fontFamily: 'ro',
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  fetchedData![index]['slug'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontFamily: 'ro',
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Veri henüz yüklenmediyse, bir yükleme göstergesi göster
                    return CircularProgressIndicator();
                  }
                },
                childCount: fetchedData != null ? fetchedData!.length : 1,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 270,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
