import 'package:flutter/material.dart';
import 'exercise_tab.dart';
import 'meditation_tab.dart';
import 'diet_tab.dart';
import 'log_tab.dart';

void main() {
  runApp(FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fitness Tracker'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Exercise'),
              Tab(text: 'Meditation'),
              Tab(text: 'Diet'),
              Tab(text: 'Logs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ExerciseTab(),
            MeditationTab(),
            DietTab(),
            LogTab(),
          ],
        ),
      ),
    );
  }
}
