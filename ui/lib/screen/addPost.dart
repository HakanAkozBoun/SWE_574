import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/consent/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/helpers/userData.dart';
import 'dart:convert';
import 'dart:io';

import 'package:recipe/screen/home.dart';
import 'package:recipe/constants/backend_url.dart';
import 'package:recipe/screen/home2.dart';

// http://10.0.2.2:8000/api

Future<List<dynamic>> fetchData() async {
  const String categoryUrl = BackendUrl.apiUrl + 'CategoryList/';

  final response = await http.get(Uri.parse(categoryUrl));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from API');
  }
}

Future<List<dynamic>> fetchData2() async {
  const String foodListUrl = BackendUrl.apiUrl + 'FoodList/';
  final response = await http.get(Uri.parse(foodListUrl));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from API');
  }
}

Future<List<dynamic>> fetchData3() async {
  const String unitListUrl = BackendUrl.apiUrl + 'UnitList/';
  final response = await http.get(Uri.parse(unitListUrl));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from API');
  }
}

Future<List<dynamic>> fetchData4(id) async {
  const String recipeList = BackendUrl.apiUrl + 'RecipeList/?blog=';
  final response = await http.get(Uri.parse(recipeList + id.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from API');
  }
}

Future<File?> pickImage() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image == null) return null;
  return File(image.path);
}

// Future<void> uploadImage(File image) async {
//   const String imageFileUrl = BackendUrl.apiUrl + 'File';

//   final request = http.MultipartRequest(
//     'POST',
//     Uri.parse(imageFileUrl),
//   );

//   // Handle potential errors during file reading
//   try {
//     final bytes = await image.readAsBytes();
//     request.files.add(http.MultipartFile.fromBytes(
//       'file',
//       bytes,
//       filename: image.path.split('/').last, // Set filename from path
//     ));
//   } on FileSystemException catch (e) {
//     print('Error reading file: $e');
//     return; // Handle error gracefully (e.g., show a user message)
//   }

//   final response = await request.send();

//   if (response.statusCode == 200) {
//     print("Yüklendi (Uploaded)"); // Use more descriptive message
//   } else {
//     print(
//         "Yükleme başarısız oldu (Upload failed). Status code: ${response.statusCode}"); // Provide error details
//   }

//   // Close the response stream to avoid resource leaks
//   await response.stream.drain();
// }

class Item {
  final int id;
  final String name;
  final String image;

  Item({required this.id, required this.name, required this.image});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class FoodItem {
  final String name;
  final int unitid;

  FoodItem({required this.name, required this.unitid});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      unitid: json['unitid'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItem &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class UnitItem {
  final int id;
  final String name;

  UnitItem({required this.id, required this.name});

  factory UnitItem.fromJson(Map<String, dynamic> json) {
    return UnitItem(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitItem &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class AddItemPage extends StatefulWidget {
  const AddItemPage(
      {super.key,
      required var this.edit,
      required Map<String, dynamic> this.item,
      required this.id});
  final edit;
  final id;
  final Map<String, dynamic> item;

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class FoodItemList {
  String food;
  String unit;
  double amount;
  int foodID;
  int unitID;

  FoodItemList(
      {required this.food,
      required this.unit,
      required this.amount,
      required this.foodID,
      required this.unitID});
}

class _AddItemPageState extends State<AddItemPage> {
  var image2, imageID;
  Item? _selectedItem;
  FoodItem? _selectedItem2;
  UnitItem? _selectedItem3;
  UserData user = UserData();

  List? foodList;
  TextEditingController _inputController1 = TextEditingController();
  TextEditingController _inputController2 = TextEditingController();
  TextEditingController _inputController3 = TextEditingController();
  TextEditingController _inputController4 = TextEditingController();
  TextEditingController _inputController5 = TextEditingController();
  // TextEditingController _inputController6 = TextEditingController();
  TextEditingController _inputController7 = TextEditingController();
  TextEditingController _inputController8 = TextEditingController();
  TextEditingController _inputController9 = TextEditingController();
  // TextEditingController _inputController10 = TextEditingController();
  TextEditingController _inputController10 = TextEditingController();

  final TextEditingController foodController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final List<FoodItemList> FoodItemLists = [];

  List<String> elemanlar = [];
  String instruction = "";
  String yeniEleman = "";

  void elemanEkle() {
    setState(() {
      elemanlar.add(yeniEleman);
      instruction +=
          "" + (elemanlar.length).toString() + "-) " + yeniEleman + "\n";
      yeniEleman = "";
    });
  }

  void elemanSil(int index) {
    setState(() {
      elemanlar.removeAt(index);
    });
  }

  String _filter = '';
  List<String> _foodList = [];
  List _foodList2 = [];
  String _foodList2VALUE = "";
  Future<void> _fetchFoodList() async {
    // const String foodListFilter = BackendUrl.apiUrl + 'FoodList?filter=$_filter';

    if (_filter.length < 3) return;

    final response = await http.get(
      Uri.parse('http://167.172.171.174:8000/api/FoodList?filter=$_filter'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      setState(() {
        _foodList = jsonData.map((item) => item['name'] as String).toList();
        _foodList2 = jsonData;
      });
    } else {
      // Hata mesajı göster
    }
  }

  Future<void> uploadImage(File image) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(BackendUrl.apiUrl + 'File/'));
    final bytes = await image.readAsBytes();
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: image.path.split('/').last, // Set filename from path
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.transform(utf8.decoder).join();
      final imageUploadResponse =
          jsonDecode(responseData) as Map<String, dynamic>;
      imageID = imageUploadResponse["id"];
      print('Resim başarıyla yüklendi.');
    } else {
      print('Resim yükleme başarısız oldu. Hata kodu: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.edit == 1 || widget.edit == 2) {
      _inputController1.text = widget.item["title"] ?? '';
      // _inputController2.text = widget.item["slug"];
      // _inputController3.text = widget.item["excerpt"];
      _inputController4.text = widget.item["content"] ?? '';
      _inputController5.text = widget.item["contentTwo"] ?? '';
      // _inputController6.text = widget.item["ingredients"];
      _inputController7.text = widget.item["preparationtime"] ?? '';
      _inputController8.text = widget.item["cookingtime"] ?? '';
      // _inputController9.text = widget.item["rate"];
      _inputController10.text = widget.item["serving"].toString();

      for (var i = 0;
          i < widget.item["contentTwo"].split("\n").length - 1;
          i++) {
        elemanlar.add(widget.item["contentTwo"].split("\n")[i]);
      }

      print(widget.item["id"]);

      fetchData2().then((data) {
        setState(() {
          foodList = data;
        });
      }).catchError((error) {
        print("Error fetching data: $error");
      });

      fetchData4(widget.item["id"]).then((data) {
        for (int i = 0; i < data.length; i++) {
          var a = foodList!
              .where((element) => element["name"] == data[i]["food"].toString())
              .first["unitid"];
          final newItem = FoodItemList(
              food: data[i]["food"].toString(),
              unit: data[i]["unit"].toString(),
              amount: double.parse(data[i]["amount"].toString()),
              foodID: a,
              unitID: int.parse(data[i]["unitid"].toString()));

          setState(() {
            FoodItemLists.add(newItem);
          });
        }
      }).catchError((error) {
        print("Error fetching data: $error");
      });
    }
    ;
  }

  Future<void> sendData(data) async {
    const String createBlogUrl = BackendUrl.apiUrl + 'CreateBlog/';
    final url = Uri.parse(createBlogUrl); // API'nin URL'si

    print(url);
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data.first),
      );

      if (response.statusCode == 200) {
        // Başarılı yanıt
        print('Data sent successfully!');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home2(userId:user.getUserId()),
          ),
        );
      } else {
        // Başarısız yanıt
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Hata durumu
      print('Error sending data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            FutureBuilder<List<dynamic>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<dynamic> data = snapshot.data!;
                  List<Item> items =
                      data.map((item) => Item.fromJson(item)).toList();

                  return DropdownButton<Item>(
                    value: _selectedItem,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: items.map((item) {
                      return DropdownMenuItem<Item>(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                    onChanged: (Item? selectedItem) {
                      setState(() {
                        _selectedItem = selectedItem;
                      });
                    },
                  );
                }
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _inputController1,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _inputController7,
              decoration: InputDecoration(labelText: 'Preparation Time'),
            ),
            TextFormField(
              controller: _inputController8,
              decoration: InputDecoration(labelText: 'Cooking Time'),
            ),
            TextFormField(
              controller: _inputController10,
              decoration: InputDecoration(labelText: 'Serving'),
            ),
            TextFormField(
              controller: _inputController4,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20.0),
            Column(
              children: [
                TextField(
                  onChanged: (text) {
                    setState(() {
                      _filter = text;
                      _fetchFoodList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Food...',
                  ),
                ),
                DropdownButton<String>(
                  // Set the initial value to null to avoid potential conflicts
                  value: _foodList.isNotEmpty ? _foodList[0] : null,
                  items: _foodList
                      // Ensure unique values by using a Set before mapping
                      .toSet() // Convert list to Set to remove duplicates
                      .map((food) => DropdownMenuItem(
                            value: food,
                            child: Text(food),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _foodList2VALUE = value!;
                  },
                ),
              ],
            ),
            FutureBuilder<List<dynamic>>(
              future: fetchData3(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<dynamic> data = snapshot.data!;
                  List<UnitItem> items3 =
                      data.map((item) => UnitItem.fromJson(item)).toList();

                  return DropdownButton<UnitItem>(
                    value: _selectedItem3,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: items3.map((item) {
                      return DropdownMenuItem<UnitItem>(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                    onChanged: (UnitItem? selectedItem) {
                      setState(() {
                        _selectedItem3 = selectedItem;
                      });
                    },
                  );
                }
              },
            ),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final food = _foodList2
                    .where((element) => element["name"] == _foodList2VALUE)
                    .first["name"];
                final unit = _selectedItem3?.name;
                final amount = double.tryParse(amountController.text) ?? 0;
                final newItem = FoodItemList(
                  food: food!,
                  unit: unit!,
                  amount: amount,
                  foodID: _foodList2
                      .where((element) => element["name"] == _foodList2VALUE)
                      .first["id"],
                  unitID: _selectedItem3!.id,
                );
                setState(() {
                  FoodItemLists.add(newItem);
                });

                foodController.clear();
                unitController.clear();
                amountController.clear();
              },
              child: Text('Add Item'),
            ),
            SizedBox(height: 20),
            Text(
              'Food Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: FoodItemLists.length,
              itemBuilder: (context, index) {
                final foodItem = FoodItemLists[index];
                return ListTile(
                  title: Text(foodItem.food),
                  subtitle: Text(
                      'Unit: ${foodItem.unit}, Amount: ${foodItem.amount}'),
                );
              },
            ),
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'New Instruction'),
                  onChanged: (deger) {
                    setState(() {
                      yeniEleman = deger;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: elemanEkle,
                  child: Text('Instruction Add'),
                ),
              ],
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: elemanlar.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(elemanlar[index]),
                  onDismissed: (direction) {
                    elemanSil(index);
                  },
                  child: ListTile(
                    title: Text(widget.edit == 1 || widget.edit == 2
                        ? elemanlar[index]
                        : "" +
                            (index + 1).toString() +
                            "-) " +
                            elemanlar[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        elemanSil(index);
                        // Snackbar gibi bir geri alma bildirimi ekleyebilirsiniz.
                      },
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final image = await pickImage();
                image2 = image.toString();
                if (image != null) {
                  await uploadImage(image);
                }
              },
              child: Text('Resim Seç'),
            ),
            ElevatedButton(
              onPressed: () {
                List<Map<String, dynamic>> dataList = [];

                if (widget.edit == 2) {
                  dataList = [
                    {
                      "category": _selectedItem?.id,
                      "title": _inputController1.text,
                      "slug": _inputController1.text
                          .toLowerCase()
                          .replaceAll(' ', '-'),
                      "excerpt": _inputController1.text,
                      "content": _inputController4.text,
                      "contentTwo": instruction,
                      "preparationtime": _inputController7.text,
                      "cookingtime": _inputController8.text,
                      "avg_rating": 0,
                      "userid": user.getUserId(),
                      "serving": _inputController10.text,
                      // "bookmark": _inputController10.text,
                      "image": imageID,
                      // "image": "image/" +
                      //     image2.toString().split("/")[7].split("'")[0],
                      "ingredients": FoodItemLists.map((item) {
                        return {
                          'food': item.food,
                          'amount': item.amount,
                        };
                      }).toList(),
                      "postlabel": "POPULAR",
                      "list": FoodItemLists.map((item) {
                        return {
                          'food': item.foodID,
                          'unit': item.unitID,
                          'amount': item.amount,
                        };
                      }).toList()
                    }
                  ];
                } else {
                  if (widget.edit == 1) {
                    dataList = [
                      {
                        "id": widget.item["id"],
                        "category": _selectedItem?.id != null
                            ? _selectedItem?.id
                            : widget.item["category"],
                        "title": _inputController1.text,
                        "slug": _inputController1.text
                            .toLowerCase()
                            .replaceAll(' ', '-'),
                        "excerpt": _inputController1.text,
                        "content": _inputController4.text,
                        "contentTwo": instruction,
                        "preparationtime": _inputController7.text,
                        "cookingtime": _inputController8.text,
                        "avg_rating": 0,
                        "userid": user.getUserId(),
                        "serving": _inputController10.text,
                        // "bookmark": _inputController10.text,
                        "image": imageID,
                        // "image": image2 != null
                        //     ? "image/" +
                        //         image2.toString().split("/")[7].split("'")[0]
                        //     : widget.item["image"].split("media/")[1],
                        "ingredients": FoodItemLists.map((item) {
                          return {
                            'food': item.food,
                            'amount': item.amount,
                          };
                        }).toList(),
                        "postlabel": "POPULAR",
                        "list": FoodItemLists.map((item) {
                          return {
                            'food': item.foodID,
                            'unit': item.unitID,
                            'amount': item.amount,
                          };
                        }).toList()
                      }
                    ];
                  } else {
                    dataList = [
                      {
                        "category": _selectedItem?.id,
                        "title": _inputController1.text,
                        "slug": _inputController1.text
                            .toLowerCase()
                            .replaceAll(' ', '-'),
                        "excerpt": _inputController1.text,
                        "content": _inputController4.text,
                        "contentTwo": instruction,
                        "preparationtime": _inputController7.text,
                        "cookingtime": _inputController8.text,
                        "avg_rating": 0,
                        "userid": user.getUserId(),
                        "serving": _inputController10.text,
                        // "bookmark": _inputController10.text,
                        "image": imageID,
                        // "image": "image/" +
                        //     image2.toString().split("/")[7].split("'")[0],
                        "ingredients": FoodItemLists.map((item) {
                          return {
                            'food': item.food,
                            'amount': item.amount,
                          };
                        }).toList(),
                        "postlabel": "POPULAR",
                        "list": FoodItemLists.map((item) {
                          return {
                            'food': item.foodID,
                            'unit': item.unitID,
                            'amount': item.amount,
                          };
                        }).toList()
                      }
                    ];
                  }
                }
                print("dataList");
                print(dataList);
                sendData(dataList);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    foodController.dispose();
    unitController.dispose();
    amountController.dispose();
    super.dispose();
  }
}













// class _FoodListScreenState extends State<FoodListScreen> {


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Food List'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             DropdownButtonFormField<String>(
//               value: selectedFood,
//               items: foods.map((food) {
//                 return DropdownMenuItem<String>(
//                   value: food.food,
//                   child: Text(food.food),
//                 );
//               }).toList(),
//               hint: Text('Select Food'),
//               onChanged: (value) {
//                 setState(() {
//                   selectedFood = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             DropdownButtonFormField<String>(
//               value: selectedUnit,
//               items: foods
//                   .where((food) => food.food == selectedFood)
//                   .map((food) {
//                 return DropdownMenuItem<String>(
//                   value: food.unit,
//                   child: Text(food.unit),
//                 );
//               }).toList(),
//               hint: Text('Select Unit'),
//               onChanged: (value) {
//                 setState(() {
//                   selectedUnit = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Amount',
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   amount = double.tryParse(value) ?? 0;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Burada seçilen food, unit ve amount değerleriyle ne yapmak istediğinizi yapabilirsiniz.
//                 print('Selected Food: $selectedFood');
//                 print('Selected Unit: $selectedUnit');
//                 print('Amount: $amount');
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





 
