import 'package:flutter/material.dart';
import 'database_helper.dart';

class MeditationTab extends StatefulWidget {
  @override
  _MeditationTabState createState() => _MeditationTabState();
}

class _MeditationTabState extends State<MeditationTab> {
  int _selectedDuration = 5;

  Future<void> _logMeditation() async {
    final date = DateTime.now().toIso8601String().split('T').first;
    await DatabaseHelper().logScore(date, 'Meditation', 20);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Meditation logged!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<int>(
            value: _selectedDuration,
            items: [1, 3, 5, 10, 15, 30, 40]
                .map((duration) => DropdownMenuItem(
                      value: duration,
                      child: Text('$duration minutes'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedDuration = value!;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _logMeditation,
            child: Text('Log Meditation'),
          ),
        ],
      ),
    );
  }
}
