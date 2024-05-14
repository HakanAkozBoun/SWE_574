import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:recipe/constants/backend_url.dart';
import 'package:recipe/helpers/userData.dart';

class AllergyPage extends StatefulWidget {
  final int? userId;

  AllergyPage({this.userId, Key? key}) : super(key: key);
  @override
  _AllergyPageState createState() => _AllergyPageState();
}

class _AllergyPageState extends State<AllergyPage> {
  List<dynamic> _allFoods = [];
  List<dynamic> _selectedFoods = [];
  String _searchQuery = '';
  var userId;

  @override
  void initState() {
    super.initState();
    fetchFoods();
      userId = widget.userId;
    //UserData userData = UserData();
    //userId = userData.getUserId();
  }

  Future<void> fetchFoods() async {
    try {
      final response = await http.get(Uri.parse(BackendUrl.apiUrl + 'FoodList/?filter='+_searchQuery));
      if (response.statusCode == 200) {
        setState(() {
          _allFoods = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load foods');
      }
    } catch (e) {
      print("Failed to fetch foods: $e");
    }
  }

  Future<void> saveAllergies() async {
    try {
      final response = await http.post(
        Uri.parse(BackendUrl.apiUrl + 'allergy/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user_id': userId,
          'food_ids': _selectedFoods.map((food) => food['id']).toList(),
        }),
      );

      if (response.statusCode == 201) {
        print('Allergies updated successfully');
      } else {
        throw Exception('Failed to save allergies');
      }
    } catch (e) {
      print("Failed to save allergies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Allergy Tracker')),
      body: Column(
        children: [
          Text(
            userId.toString(),
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'ro',
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });

                fetchFoods();
              },
              decoration: InputDecoration(
                labelText: 'Search Food',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _allFoods.length,
              itemBuilder: (context, index) {
                final food = _allFoods[index];

                  return ListTile(
                    title: Text(food['name']),
                    trailing: Checkbox(
                      value: _selectedFoods.contains(food),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            if (!_selectedFoods.contains(food)) {
                              _selectedFoods.add(food);
                            }
                          } else {
                            _selectedFoods.removeWhere((item) => item['id'] == food['id']);
                          }
                        });
                      },
                    ),
                  );
              },
            ),
          ),
          ElevatedButton(
            onPressed: saveAllergies,
            child: Text('Save Allergies'),
          )
        ],
      ),
    );
  }
}
