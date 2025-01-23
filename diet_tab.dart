import 'package:flutter/material.dart';
import 'database_helper.dart';

class DietTab extends StatefulWidget {
  @override
  _DietTabState createState() => _DietTabState();
}

class _DietTabState extends State<DietTab> {
  final TextEditingController _foodController = TextEditingController();

  Future<void> _logMeal(String mealType) async {
    final date = DateTime.now().toIso8601String().split('T').first;
    await DatabaseHelper().logFood(date, mealType, 'Healthy Meal');
    await DatabaseHelper().logScore(date, 'Healthy $mealType', 10);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$mealType logged!')),
    );
  }

  Future<void> _logCustomFood() async {
    if (_foodController.text.isNotEmpty) {
      final date = DateTime.now().toIso8601String().split('T').first;
      await DatabaseHelper().logFood(date, 'Custom', _foodController.text);
      _foodController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food logged!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _logMeal('Breakfast'),
            child: Text('Breakfast Done'),
          ),
          ElevatedButton(
            onPressed: () => _logMeal('Lunch'),
            child: Text('Lunch Done'),
          ),
          ElevatedButton(
            onPressed: () => _logMeal('Dinner'),
            child: Text('Dinner Done'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _foodController,
            decoration: InputDecoration(
              hintText: 'Enter food details...',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _logCustomFood,
            child: Text('Log Food'),
          ),
        ],
      ),
    );
  }
}
