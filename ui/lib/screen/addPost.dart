import 'package:flutter/material.dart';
import 'package:recipe/consent/appbar.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class FoodItem {
  String food;
  String unit;
  double amount;

  FoodItem({required this.food, required this.unit, required this.amount});
}

class _AddItemPageState extends State<AddItemPage> {
  String _selectedItem = 'Turkish Food';
  TextEditingController _inputController1 = TextEditingController();
  TextEditingController _inputController2 = TextEditingController();
  TextEditingController _inputController3 = TextEditingController();
  TextEditingController _inputController4 = TextEditingController();
  TextEditingController _inputController5 = TextEditingController();
  TextEditingController _inputController6 = TextEditingController();

  final TextEditingController foodController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final List<FoodItem> foodItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedItem,
              onChanged: (var newValue) {
                setState(() {
                  _selectedItem = newValue!;
                });
              },
              items: ['Turkish Food', 'BreakFast', 'Kebab']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Category',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _inputController1,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _inputController2,
              decoration: InputDecoration(labelText: 'Slug'),
            ),
            TextFormField(
              controller: _inputController3,
              decoration: InputDecoration(labelText: 'Excerpt'),
            ),
            TextFormField(
              controller: _inputController4,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _inputController5,
              decoration: InputDecoration(labelText: 'Instruction List'),
            ),
            TextFormField(
              controller: _inputController6,
              decoration: InputDecoration(labelText: 'Ingredients List Name'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: foodController,
              decoration: InputDecoration(labelText: 'Food'),
            ),
            TextFormField(
              controller: unitController,
              decoration: InputDecoration(labelText: 'Unit'),
            ),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final food = foodController.text;
                final unit = unitController.text;
                final amount = double.tryParse(amountController.text) ?? 0;
                final newItem =
                    FoodItem(food: food, unit: unit, amount: amount);
                foodItems.add(newItem);
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
              shrinkWrap: true,
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final foodItem = foodItems[index];
                return ListTile(
                  title: Text(foodItem.food),
                  subtitle: Text(
                      'Unit: ${foodItem.unit}, Amount: ${foodItem.amount}'),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Ekleme işlemi burada yapılacak
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
