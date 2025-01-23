// TODO Implement this library.
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class LogTab extends StatefulWidget {
  @override
  _LogTabState createState() => _LogTabState();
}

class _LogTabState extends State<LogTab> {
  DateTime _selectedDate = DateTime.now();
  int _totalScore = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadLogs();
    }
  }

  Future<void> _loadLogs() async {
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final totalScore = await DatabaseHelper().getTotalScore(date);
    setState(() {
      _totalScore = totalScore;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Date'),
          ),
          SizedBox(height: 20),
          Text('Total Score: $_totalScore', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
