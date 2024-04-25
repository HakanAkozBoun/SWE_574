import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:recipe/consent/appbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart' show rootBundle;

class TrackingDietGoals extends StatefulWidget {
  @override
  _TrackingDietGoalsState createState() => _TrackingDietGoalsState();
}

class _TrackingDietGoalsState extends State<TrackingDietGoals> {
  List<Map<String, dynamic>> _nutritionData = [];

  bool _showTable = true;

  @override
  void initState() {
    super.initState();
    loadNutritionData();
  }

  Future<void> loadNutritionData() async {
    // Load JSON file
    String jsonString =
        await rootBundle.loadString('assets/nutrition_data.json');
    List<dynamic> jsonData = json.decode(jsonString);

    // Calculate remaining value for each row
    for (var item in jsonData) {
      double goal = item['goal'];
      double currentIntake = item['currentIntake'];
      double remaining = goal - currentIntake;
      remaining = double.parse(remaining.toStringAsFixed(2));
      item['remaining'] = remaining;
    }

    jsonData.sort((a, b) => a['nutritionName'].compareTo(b['nutritionName']));

    setState(() {
      _nutritionData = List<Map<String, dynamic>>.from(jsonData);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

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
                    _showTable = true; // Show table view
                  });
                },
                child: Text('Table'),
              ),
              SizedBox(width: 20), // Add spacing between buttons
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTable = false; // Show chart view
                  });
                },
                child: Text('Chart'),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _showTable ? days.map((day) => _buildDayCell(day)).toList() : [], 
            ),
          ),
          _showTable ? _buildTable(_nutritionData) : _buildChart(),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

Widget _buildChart() {
  final List<ChartData> chartData = [
    ChartData("Monday", 35.0),
    ChartData("Tuesday", 28.0),
    ChartData("Wednesday", 34.0),
    ChartData("Thursday", 32.0),
    ChartData("Friday", 40.0),
    ChartData("Saturday", 30.0),
    ChartData("Sunday", 45.0),
  ];

    final List<ChartData> chartData2 = [
    ChartData("Monday", 23.0),
    ChartData("Tuesday", 56.0),
    ChartData("Wednesday", 21.0),
    ChartData("Thursday", 54.0),
    ChartData("Friday", 89.0),
    ChartData("Saturday", 51.0),
    ChartData("Sunday", 21.0),
  ];
   return Container(
    child: SfCartesianChart(
      primaryXAxis: CategoryAxis(), // Use CategoryAxis for the x-axis
      series: <CartesianSeries>[
        // Renders line chart
        LineSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        ),
        LineSeries<ChartData, String>(
          dataSource: chartData2,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
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
          // Define rows with style
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

Widget _buildDayCell(String day) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: TextButton(
      onPressed: () {
        // Handle button press here
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        print('Clicked on $day. Current date: $currentDate');
      },
      child: Text(
        day,
        style: TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    ),
  );
}
