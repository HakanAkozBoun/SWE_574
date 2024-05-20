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
  List<dynamic> _userAllergies = [];
  String _searchQuery = '';
  var userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    fetchFoods();
    fetchAllergies();
  }

  Future<void> fetchFoods() async {
    try {
      final response = await http.get(Uri.parse(BackendUrl.apiUrl + 'FoodList/?filter=' + _searchQuery));
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

  Future<void> fetchAllergies() async {
    if (userId == null) {
      print("User ID is null");
      return;
    }
    
    try {
      final response = await http.get(Uri.parse(BackendUrl.apiUrl + 'allergy/?user_id=$userId'));
      print(response.body);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Fetched allergies: $responseBody");
        setState(() {
          _userAllergies = responseBody;
          _selectedFoods = List<dynamic>.from(_userAllergies);
        });
      } else {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to load allergies');
      }
    } catch (e) {
      print("Failed to  fetch allergies: $e");
    }
  }

  Future<void> saveAllergies() async {
    if (userId == null) {
      print("User ID is null");
      return;
    }

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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Allergies updated successfully'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Foods you have added as allergenic are filtered when searching for recipes in the search bar. You can safely consume the foods you see in the search results!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Allergies',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ..._userAllergies.map((food) {
                  print("Food item: $food");
                  return Text(food['food']['name']);
                }).toList(),
              ],
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
