import 'package:fitness_tracker/database_helper.dart';
import 'package:flutter/material.dart';

abstract class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);
}

abstract class WorkoutScreenState<T extends WorkoutScreen> extends State<T> {
  Future<void> showWorkoutCompleteDialog(String workoutName) async {
    await DatabaseHelper().logActivity(workoutName, '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$workoutName Complete!'),
          content:
              Text('Great job! You’ve finished your $workoutName session.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
