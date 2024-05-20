import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe/screen/recipe.dart' as RecipeScreen;
import 'package:recipe/models/recipe.dart';
import 'package:recipe/constants/backend_url.dart';
import 'package:recipe/helpers/userData.dart';


class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchResult;
  const SearchBarWidget({Key? key, required this.onSearchResult}) : super(key: key);
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}
class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController controller;
  List data = [];
  @override 
  void initState() {
    super.initState();
    controller = TextEditingController();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> searchRecipes(String query) async {
    UserData userData = UserData();
    int? userId = userData.getUserId();
    var url = Uri.parse(BackendUrl.apiUrl + 'search/?query=$query');
    if (userId != null) {
      url = Uri.parse(BackendUrl.apiUrl + 'search/?query=$query&id=$userId');
    }
    
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      this.data = json.decode(response.body);
      widget.onSearchResult(response.body);
    } else {
      widget.onSearchResult('Failed to load search results');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                this.searchRecipes('');
                controller.openView();
              },
              onSubmitted: (input) {
                controller.openView();
              },
              leading: const Icon(Icons.search),          
            );
          }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
            return this.data.map((item) {
              return ListTile(
                title: Text(item['title']),
                onTap: () {
                  String slug = item['slug'].toString();
                  int id = item['id'];

                  Widget selectedRecipe = RecipeScreen.Recipe(
                    slug: slug,
                    id: id,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => selectedRecipe,
                    ),
                  );
                },
              );
            });
          })
      ),
    );
  }
}