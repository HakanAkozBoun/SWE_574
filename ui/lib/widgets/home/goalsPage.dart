import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/models/goal.dart';

// ignore: must_be_immutable
class GoalsPage extends StatefulWidget {
  final int userId;

  GoalsPage({required this.userId, Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  late Future<List<Goal>> userGoals;
  @override
  void initState() {
    super.initState();
    userGoals = Goal.fetchGoals(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: SafeArea(
            child: FutureBuilder<List<Goal>>(
          future: userGoals,
          builder: (BuildContext context, AsyncSnapshot<List<Goal>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: background,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                backgroundColor: background,
                body: Center(
                  child: NoGoalsFlow(context),
                ),
              );
            } else if (snapshot.hasData) {
              List<Goal> userGoals = snapshot.data!;
              return Column(
                children: [
                  Flexible(
                    child: GoalsList(context, userGoals),
                  ),
                ],
              );
            } else {
              return Scaffold(
                backgroundColor: background,
                body: Center(
                  child: Text("No data available"),
                ),
              );
            }
          },
        )));
  }

  void _showSubPage(BuildContext context, String tileTitle, String goalName,
      String goalAmountStr, bool goalExists) {
    TextEditingController textEditingController =
        TextEditingController(text: goalAmountStr);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.5, // ekranın tamamını kaplamasın diye
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: tileTitle,
                  ),
                  autofocus: true,
                ),
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 50),
                  IconButton(
                    iconSize: 100,
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 50),
                  IconButton(
                    iconSize: 100,
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      UpdateShownInfo(
                          goalName, textEditingController.text, goalExists);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  UpdateShownInfo(
      String goalName, String goalAmountStr, bool goalExists) async {
    double? goalAmount = double.tryParse(goalAmountStr);
    var success;
    if (goalAmount == null) {
      showAlertDialog(context, "Please enter a valid number");
    } else {
      Goal goal = Goal(goalNutrition: goalName, goalAmount: goalAmount);
      if (goalExists) {
        print("updateGoal called");
        success = await goal.updateGoal(widget.userId, goalName, goalAmount);
      } else {
        print("createGoal called");
        success = await goal.createGoal(widget.userId, goalName, goalAmount);
        print(success);
      }
      if (success) {
        Navigator.pop(context);
        showAlertDialog(context, "Goal updated successfully");
      } else {
        showAlertDialog(context, "Failed to update goal");
      }

      List<Goal> updatedGoals = await Goal.fetchGoals(widget.userId);
      setState(() {
        userGoals = Future.value(updatedGoals);
      });
    }
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invalid Input"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  bool getgoalExistence(double? goalAmount) {
    if (goalAmount != null) {
      return true;
    }
    return false;
  }

  double? getgoalAmount(List<Goal> goals, String goalNutrition) {
    for (int i = 0; i < goals.length; i++) {
      if (goals[i].goalNutrition == goalNutrition) {
        return goals[i].goalAmount;
      }
    }
    return null;
  }

  Widget NoGoalsFlow(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CorrespondingTile("Calories (Kcal)", "calorie", null, false, context),
          CorrespondingTile("Fat (mg)", "fat", null, false, context),
          CorrespondingTile("Sodium (mg)", "sodium", null, false, context),
          CorrespondingTile("Calcium (mg)", "calcium", null, false, context),
          CorrespondingTile("Protein (mg)", "protein", null, false, context),
          CorrespondingTile("Iron (mg)", "iron", null, false, context),
          CorrespondingTile(
              "Carbonhydrates (mg)", "carbonhydrates", null, false, context),
          CorrespondingTile("Sugars (mg)", "sugars", null, false, context),
          CorrespondingTile("Fiber (mg)", "fiber", null, false, context),
          CorrespondingTile("Vitamin A (mg)", "vitamina", null, false, context),
          CorrespondingTile("Vitamin B (mg)", "vitaminb", null, false, context),
          CorrespondingTile("Vitamin D (mg)", "vitamind", null, false, context),
        ],
      ),
    );
  }

  Widget GoalsList(BuildContext context, List<Goal> goals) {
    double? calorieAmount = getgoalAmount(goals, "calorie");
    double? fatAmount = getgoalAmount(goals, "fat");
    double? sodiumAmount = getgoalAmount(goals, "sodium");
    double? calciumAmount = getgoalAmount(goals, "calcium");
    double? proteinAmount = getgoalAmount(goals, "protein");
    double? ironAmount = getgoalAmount(goals, "iron");
    double? carbonhydratesAmount = getgoalAmount(goals, "carbonhydrates");
    double? sugarsAmount = getgoalAmount(goals, "sugars");
    double? fiberAmount = getgoalAmount(goals, "fiber");
    double? vitaminaAmount = getgoalAmount(goals, "vitamina");
    double? vitaminbAmount = getgoalAmount(goals, "vitaminb");
    double? vitamindAmount = getgoalAmount(goals, "vitamind");
    bool calorieExists = getgoalExistence(calorieAmount);
    bool fatExists = getgoalExistence(fatAmount);
    bool sodiumExists = getgoalExistence(sodiumAmount);
    bool calciumExists = getgoalExistence(calciumAmount);
    bool proteinExists = getgoalExistence(proteinAmount);
    bool ironExists = getgoalExistence(ironAmount);
    bool carbonhydratesExists = getgoalExistence(carbonhydratesAmount);
    bool sugarsExists = getgoalExistence(sugarsAmount);
    bool fiberExists = getgoalExistence(fiberAmount);
    bool vitaminaExists = getgoalExistence(vitaminaAmount);
    bool vitaminbExists = getgoalExistence(vitaminbAmount);
    bool vitamindExists = getgoalExistence(vitamindAmount);
    return SingleChildScrollView(
      child: Column(
        children: [
          CorrespondingTile("Calories (mg)", "calorie", calorieAmount,
              calorieExists, context),
          CorrespondingTile("Fat (mg)", "fat", fatAmount, fatExists, context),
          CorrespondingTile(
              "Sodium (mg)", "sodium", sodiumAmount, sodiumExists, context),
          CorrespondingTile(
              "Calcium (mg)", "calcium", calciumAmount, calciumExists, context),
          CorrespondingTile(
              "Protein (mg)", "protein", proteinAmount, proteinExists, context),
          CorrespondingTile(
              "Iron (mg)", "iron", ironAmount, ironExists, context),
          CorrespondingTile("Carbonhydrates (mg)", "carbonhydrates",
              carbonhydratesAmount, carbonhydratesExists, context),
          CorrespondingTile(
              "Sugars (mg)", "sugars", sugarsAmount, sugarsExists, context),
          CorrespondingTile(
              "Fiber (mg)", "fiber", fiberAmount, fiberExists, context),
          CorrespondingTile("Vitamin A (mg)", "vitamina", vitaminaAmount,
              vitaminaExists, context),
          CorrespondingTile("Vitamin B (mg)", "vitaminb", vitaminbAmount,
              vitaminbExists, context),
          CorrespondingTile("Vitamin D (mg)", "vitamind", vitamindAmount,
              vitamindExists, context),
        ],
      ),
    );
  }

  ListTile CorrespondingTile(String tileTitle, String goalName,
      double? goalAmount, bool goalExists, BuildContext context) {
    String goalAmountStr = "";
    if (goalExists) {
      goalAmountStr = goalAmount.toString();
    }
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            tileTitle,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 10),
          Text(
            goalAmountStr,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showSubPage(context, tileTitle, goalName, goalAmountStr, goalExists);
        },
      ),
    );
  }
}
