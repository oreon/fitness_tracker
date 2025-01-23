import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class LogTab extends StatefulWidget {
  @override
  _LogTabState createState() => _LogTabState();
}

class _LogTabState extends State<LogTab> {
  DateTime _selectedDate = DateTime.now(); // Default to today's date
  Map<String, List<Map<String, dynamic>>> _logs = {
    'food': [],
    'exercise': [],
    'meditation': [],
  };

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

    // Fetch food logs
    final foodLogs = await DatabaseHelper().getFoodLogs(date);

    // Fetch exercise logs
    final exerciseLogs = await DatabaseHelper().getExerciseLogs(date);

    // Fetch meditation logs
    final meditationLogs = await DatabaseHelper().getMeditationLogs(date);

    setState(() {
      _logs = {
        'food': foodLogs,
        'exercise': exerciseLogs,
        'meditation': meditationLogs,
      };
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLogs(); // Load logs for today when the tab is opened
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
          Text(
            'Logs for ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildLogSection('Food Logs', _logs['food']!),
                _buildLogSection('Exercise Logs', _logs['exercise']!),
                _buildLogSection('Meditation Logs', _logs['meditation']!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogSection(String title, List<Map<String, dynamic>> logs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (logs.isEmpty) Text('No logs found for this date.'),
        for (final log in logs)
          ListTile(
            title: Text(log['details'] ?? 'No details'),
            subtitle: Text(_formatTime((log['time'])) ?? 'No time'),
          ),
        SizedBox(height: 20),
      ],
    );
  }

  // Format time as "9:00 AM"
  String _formatTime(String? dateTime) {
    if (dateTime == null) return 'No time';
    final parsedDate = DateTime.tryParse(dateTime);
    if (parsedDate == null) return 'No time';
    return DateFormat('h:mm a').format(parsedDate); // Format only the time
  }
}
