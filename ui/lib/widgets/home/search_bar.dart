import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> performSearch() async {
    var response = await http.get(Uri.parse('http://10.0.2.2:8000/search?query=${_searchController.text}'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // Bu kısım sonuçları kullanıcıya göstermek için UI güncellemesi yapılacak yerdir
      print(data);
    } else {
      // Arama başarısız olursa hata mesajı göster
      print('Search failed with status: ${response.statusCode}');
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
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for recipes',
                ),
                onSubmitted: (value) {
                  performSearch();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
