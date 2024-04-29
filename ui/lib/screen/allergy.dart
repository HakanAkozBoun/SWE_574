import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:recipe/constants/backend_url.dart';

class AllergyPage extends StatefulWidget {
  const AllergyPage({Key? key}) : super(key: key);

  @override
  _AllergyPageState createState() => _AllergyPageState();
}

class _AllergyPageState extends State<AllergyPage> {
  List<dynamic> _allFoods = [];
  List<dynamic> _selectedFoods = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    try {
      final response = await http.get(Uri.parse(BackendUrl.apiUrl + 'FoodList/'));
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
        Uri.parse(BackendUrl.apiUrl + 'AddAllergy/'), // Change this to the correct API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user_id': 'your_user_id',
          'food_ids': _selectedFoods.map((food) => food['id']).toList(),
        }),
      );

      if (response.statusCode == 200) {
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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
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
                if (food['name'].toLowerCase().contains(_searchQuery)) {
                  return ListTile(
                    title: Text(food['name']),
                    trailing: Checkbox(
                      value: _selectedFoods.contains(food),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            _selectedFoods.add(food);
                          } else {
                            _selectedFoods.remove(food);
                          }
                        });
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              saveAllergies();
            },
            child: Text('Save Allergies'),
          )
        ],
      ),
    );
  }
}
