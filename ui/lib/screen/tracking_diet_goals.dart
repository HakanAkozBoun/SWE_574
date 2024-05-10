import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/constants/backend_url.dart';
import 'package:recipe/helpers/userData.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TrackingDietGoals extends StatefulWidget {
  @override
  _TrackingDietGoalsState createState() => _TrackingDietGoalsState();
}

class _TrackingDietGoalsState extends State<TrackingDietGoals> {
  UserData user = UserData();
  var userId;

  DateTime _selectedDate = DateTime.now();
  var nutrient_items = [
    'Protein',
    'Carbohydrates',
    'Fats',
    'Vitamin A',
    'Vitamin C',
  ];
  late String nutrientName;

  List<Map<String, dynamic>> _nutritionData = [];
  bool _showTable = true;

  @override
  void initState() {
    super.initState();
    nutrientName = nutrient_items[0];
    // userId = user.getUserId();
    userId = "23";
    loadNutritionData(_selectedDate);
  }

  Future<void> loadNutritionData(DateTime selectedDate) async {
    String url = BackendUrl.apiUrl +
        "DailyNutritionWithGoals?user=$userId&selected_date=${DateFormat('yyyy-MM-dd').format(selectedDate)}";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          List<dynamic> data = jsonResponse;

          data.forEach((item) {
            double goal = item['goal'].toDouble();
            double currentIntake = item['currentIntake'].toDouble();
            double remaining = goal - currentIntake;
            remaining = double.parse(remaining.toStringAsFixed(2));
            item['remaining'] = remaining;
          });

          // Sorting by 'nutritionName'
          data.sort((a, b) => a['nutritionName'].compareTo(b['nutritionName']));

          setState(() {
            _nutritionData = List<Map<String, dynamic>>.from(data);
          });
        } else {
          print('Invalid response format: $jsonResponse');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Future<void> loadNutritionData() async {
  //   String jsonString =
  //       await rootBundle.loadString('assets/nutrition_data.json');
  //   List<dynamic> jsonData = json.decode(jsonString);

  //   for (var item in jsonData) {
  //     double goal = item['goal'];
  //     double currentIntake = item['currentIntake'];
  //     double remaining = goal - currentIntake;
  //     remaining = double.parse(remaining.toStringAsFixed(2));
  //     item['remaining'] = remaining;
  //   }

  //   jsonData.sort((a, b) => a['nutritionName'].compareTo(b['nutritionName']));

  //   setState(() {
  //     _nutritionData = List<Map<String, dynamic>>.from(jsonData);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Tracking Diet Goals',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTable = true;
                  });
                },
                child: Text('Table'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTable = false;
                  });
                },
                child: Text('Chart'),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          if (_showTable)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(Duration(days: 1));
                      loadNutritionData(_selectedDate);
                    });
                  },
                  icon: Icon(Icons.arrow_left),
                ),
                Text(
                  DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(Duration(days: 1));
                      loadNutritionData(_selectedDate);
                    });
                  },
                  icon: Icon(Icons.arrow_right),
                ),
              ],
            ),
          if (_showTable)
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text('Select Date'),
            ),
          if (!_showTable && nutrientName != "") ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                value: nutrientName,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: nutrient_items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(
                    () {
                      nutrientName = newValue!;
                    },
                  );
                },
              ),
            ),
          ],
          SizedBox(height: 20),
          _showTable ? _buildTable(_nutritionData) : _buildChart(),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

Widget _buildChart() {
  final List<ChartData> chartData = [
    ChartData("08/05/2024", 100.0),
    ChartData("09/05/2024", 100.0),
    ChartData("10/05/2024", 100.0),
    ChartData("11/05/2024", 100.0),
    ChartData("12/05/2024", 100.0),
    ChartData("13/05/2024", 100.0),
    ChartData("14/05/2024", 100.0),
  ];

  final List<ChartData> chartData2 = [
    ChartData("08/05/2024", 23.0),
    ChartData("09/05/2024", 56.0),
    ChartData("10/05/2024", 121.0),
    ChartData("11/05/2024", 54.0),
    ChartData("12/05/2024", 189.0),
    ChartData("13/05/2024", 51.0),
    ChartData("14/05/2024", 121.0),
  ];
  return Container(
    child: SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      legend: Legend(isVisible: true),
      series: <CartesianSeries>[
        LineSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          name: 'Goal',
        ),
        LineSeries<ChartData, String>(
          dataSource: chartData2,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          name: 'Intake',
        ),
      ],
    ),
  );
}

Widget _buildTable(List<Map<String, dynamic>> nutritionData) {
  return Expanded(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Nutrient Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Goal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Intake',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Remaining',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: nutritionData.map((item) {
            print(item);
            return DataRow(
              cells: [
                DataCell(Text(item['nutritionName'])),
                DataCell(Text(item['goal'].toString())),
                DataCell(Text(item['currentIntake'].toString())),
                DataCell(Text(item['remaining'].toString())),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}
