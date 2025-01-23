import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // For playing sounds
import 'database_helper.dart';

class ExerciseTab extends StatefulWidget {
  @override
  _ExerciseTabState createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> _exercises = [
    'Squats',
    'Lunges',
    'Side Lunges',
    'Glute Bridges',
  ];
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  int _timeRemaining = 0;
  bool _isWorkoutActive = false;
  bool _isRestPeriod = false;
  String _currentStatus = 'Press Start to Begin';

  Future<void> _playSound(String soundFile) async {
    await _audioPlayer.play(AssetSource('sounds/$soundFile'));
  }

  void _startWorkout() {
    setState(() {
      _isWorkoutActive = true;
      _currentStatus = 'Get Ready!';
    });

    Future.delayed(Duration(seconds: 3), () {
      _startExercise();
    });
  }

  void _startExercise() {
    if (_currentExerciseIndex >= _exercises.length) {
      _currentSet++;
      if (_currentSet > 3) {
        _endWorkout();
        return;
      }
      _currentExerciseIndex = 0;
    }

    setState(() {
      _isRestPeriod = false;
      _timeRemaining = 45;
      _currentStatus =
          '${_exercises[_currentExerciseIndex]} - Set $_currentSet';
    });

    _playSound('start_sound.mp3');

    _startTimer();
  }

  void _startRest() {
    setState(() {
      _isRestPeriod = true;
      _timeRemaining = 15;
      _currentStatus = 'Rest - Set $_currentSet';
    });

    _playSound('rest_sound.mp3');

    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
        _startTimer();
      } else {
        if (_isRestPeriod) {
          _currentExerciseIndex++;
          _startExercise();
        } else {
          _startRest();
        }
      }
    });
  }

  void _endWorkout() {
    setState(() {
      _isWorkoutActive = false;
      _currentStatus = 'Workout Complete!';
      _currentExerciseIndex = 0;
      _currentSet = 1;
    });

    // Log the workout
    final date = DateTime.now().toIso8601String().split('T').first;
    DatabaseHelper().logScore(date, 'Workout', 30);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            _currentStatus,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Time Remaining: $_timeRemaining seconds',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          if (!_isWorkoutActive)
            ElevatedButton(
              onPressed: _startWorkout,
              child: Text('Start Workout'),
            ),
          if (_isWorkoutActive)
            ElevatedButton(
              onPressed: _endWorkout,
              child: Text('Stop Workout'),
            ),
        ],
      ),
    );
  }
}
