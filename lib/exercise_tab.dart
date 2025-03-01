import 'package:fitness_tracker/kickboxing_screen.dart';
import 'package:fitness_tracker/lowerbody_strength.dart';
import 'package:fitness_tracker/pranayama_screen.dart';
import 'package:fitness_tracker/yoga_screen.dart';
import 'package:flutter/material.dart';

import 'exercise_screen.dart';

class ExerciseTab extends StatelessWidget {
  const ExerciseTab({Key? key}) : super(key: key);

  void _launchExerciseRoutine(BuildContext context) {
    // Your existing code for launching the exercise routine
    // For example:
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LowerBodyWorkoutScreen()));
  }

  void _launchYoga(BuildContext context) {
    // Code to launch yoga routine
    // For example:
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => YogaScreen()));
  }

  void _launchPranayama(BuildContext context) {
    // Code to launch pranayama routine
    // For example:
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PranayamaScreen()));
  }

  void _launchKickboxing(BuildContext context) {
    // Code to launch kickboxing routine
    // For example:
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KickboxingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _launchExerciseRoutine(context),
              child: Text('Exercise'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchYoga(context),
              child: Text('Yoga'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchPranayama(context),
              child: Text('Pranayama'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchKickboxing(context),
              child: Text('Kickboxing'),
            ),
          ],
        ),
      ),
    );
  }
}
