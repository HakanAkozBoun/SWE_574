import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:recipe/consent/appbar.dart';
import 'package:fl_chart/fl_chart.dart';

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
          _showTable ? _buildTable(_nutritionData) : _buildChart(),
        ],
      ),
    );
  }
}

Widget _buildChart() {
  return (Text("dsf"));
  // return _nutritionData.isEmpty
  //       ? Center(child: CircularProgressIndicator()) // Show loading indicator while data is loading
  //       : BarChart(
  //           BarChartData(
  //             alignment: BarChartAlignment.spaceAround,
  //             maxY: getMaxYValue(),
  //             groupsSpace: 16,
  //             barTouchData: BarTouchData(enabled: false),
  //             titlesData: FlTitlesData(
  //               show: true,
  //               bottomTitles: titles(
  //                 showTitles: true,
  //                 getTitles: (value) {
  //                   return _nutritionData[value.toInt()]['nutritionName'];
  //                 },
  //               ),
  //               leftTitles: SideTitles(
  //                 showTitles: true,
  //                 getTitles: (value) {
  //                   return value.toInt().toString();
  //                 },
  //               ),
  //             ),
  //             borderData: FlBorderData(show: false),
  //             barGroups: createSeriesData(),
  //           ),
  //         );
}

List<BarChartGroupData> createSeriesData(
    List<Map<String, dynamic>> nutritionData) {
  List<BarChartGroupData> seriesData = [];
  for (int i = 0; i < nutritionData.length; i++) {
    Map<String, dynamic> nutrition = nutritionData[i];
    seriesData.add(BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: nutrition['currentIntake'],
          color: Colors.blue,
          width: 16,
        ),
        BarChartRodData(
          toY: nutrition['goal'],
          color: Colors.red,
          width: 16,
        ),
      ],
      showingTooltipIndicators: [0],
    ));
  }

  return seriesData;
}

// Function to calculate the maximum Y value for the chart
double getMaxYValue(List<Map<String, dynamic>> nutritionData) {
  double maxIntake = nutritionData
      .map((e) => e['currentIntake'])
      .reduce((a, b) => a > b ? a : b);
  double maxGoal =
      nutritionData.map((e) => e['goal']).reduce((a, b) => a > b ? a : b);
  return maxIntake > maxGoal ? maxIntake : maxGoal;
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
            double remainingValue = item['remaining'];
            Color textColor = remainingValue > 0 ? Colors.red : Colors.green;

            return DataRow(cells: [
              DataCell(Text(item['nutritionName'])),
              DataCell(Text(item['goal'].toString())),
              DataCell(Text(item['currentIntake'].toString())),
              DataCell(Text(
                // show abstract value of remaining
                remainingValue.abs().toString(),
                style: TextStyle(color: textColor),
              )),
            ]);
          }).toList(),
        ),
      ),
    ),
  );
}
