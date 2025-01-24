import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class LowerBodyWorkoutScreen extends StatefulWidget {
  const LowerBodyWorkoutScreen({Key? key}) : super(key: key);

  @override
  _LowerBodyWorkoutScreenState createState() => _LowerBodyWorkoutScreenState();
}

class _LowerBodyWorkoutScreenState extends State<LowerBodyWorkoutScreen> {
  final List<Map<String, dynamic>> _exercises = [
    {
      'name': 'Squats',
      'image': 'assets/images/lower/squat.gif',
    },
    {
      'name': 'Right Lunge',
      'image': 'assets/images/lower/lunge.gif',
    },
    {
      'name': 'Left Lunge',
      'image': 'assets/images/lower/lunge.gif',
    },
    {
      'name': 'Side Lunges Right',
      'image': 'assets/images/lower/side_lunge.gif',
    },
    {
      'name': 'Side Lunges Left',
      'image': 'assets/images/lower/side_lunge.gif',
    },
    {
      'name': 'Glute Bridge',
      'image': 'assets/images/lower/glute_bridge.gif',
    },
  ];

  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  int _timerSeconds = 45; // 45 seconds of work
  bool _isWorkPhase = true; // Tracks if it's work or rest phase
  bool _isPaused = false; // Tracks if the workout is paused
  late Timer _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _playStartAudio(); // Play start audio when the workout begins
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_timerSeconds > 0) {
            _timerSeconds--;
          } else {
            if (_isWorkPhase) {
              // Switch to rest phase
              _isWorkPhase = false;
              _timerSeconds = 15; // 15 seconds of rest
              _playRestAudio(); // Play rest audio when rest phase begins
            } else {
              // Switch to next exercise
              _isWorkPhase = true;
              _timerSeconds = 45; // 45 seconds of work
              if (_currentExerciseIndex < _exercises.length - 1) {
                _currentExerciseIndex++;
              } else {
                // Move to the next set
                if (_currentSet < 3) {
                  _currentSet++;
                  _currentExerciseIndex = 0; // Reset to the first exercise
                } else {
                  _timer.cancel(); // End workout after 3 sets
                  _navigateToCompletionScreen();
                }
              }
              _playStartAudio(); // Play start audio when work phase begins
            }
          }
        });
      }
    });
  }

  void _playStartAudio() async {
    await _audioPlayer
        .play(AssetSource('sounds/start_sound.mp3')); // Play start audio
  }

  void _playRestAudio() async {
    await _audioPlayer
        .play(AssetSource('sounds/tibet_bell.wav')); // Play rest audio
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    if (!_isPaused) {
      _playStartAudio(); // Play start audio when resuming
    }
  }

  void _endWorkout() {
    _timer.cancel();
    _navigateToCompletionScreen();
  }

  void _navigateToCompletionScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutCompletionScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lower Body Workout'),
      ),
      body: Column(
        children: [
          // Full-width image for the current exercise
          Card(
            elevation: 5,
            margin: EdgeInsets.zero, // Remove default margin
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height *
                  0.5, // 30% of screen height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: AssetImage(_exercises[_currentExerciseIndex]['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Set $_currentSet of 3',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _isWorkPhase ? 'Work' : 'Rest',
                    style: TextStyle(
                      fontSize: 20,
                      color: _isWorkPhase ? Colors.green : Colors.orange,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _exercises[_currentExerciseIndex]['name'],
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${_timerSeconds ~/ 60}:${(_timerSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _togglePause,
                        child: Text(_isPaused ? 'Resume' : 'Pause'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _endWorkout,
                        child: Text('End Workout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutCompletionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Complete'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Great job!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You’ve finished your lower body workout.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
