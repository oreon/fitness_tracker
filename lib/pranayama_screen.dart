import 'package:fitness_tracker/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class PranayamaScreen extends WorkoutScreen {
  const PranayamaScreen({Key? key}) : super(key: key);

  @override
  _PranayamaScreenState createState() => _PranayamaScreenState();
}

class _PranayamaScreenState extends WorkoutScreenState<PranayamaScreen> {
  final List<Map<String, dynamic>> pranayamaTechniques = [
    {'name': 'Bhastrika', 'duration': 180}, // 3 minutes
    {'name': 'Kapalbhati', 'duration': 300}, // 5 minutes
    {'name': 'Nadi Shodhan', 'duration': 420}, // 7 minutes
    {'name': 'Bhramari', 'duration': 120}, // 2 minutes
    {'name': 'Ujjayi', 'duration': 180}, // 3 minutes
  ];

  int currentTechniqueIndex = 0;
  int timerSeconds = 0;
  late Timer timer;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    timerSeconds = pranayamaTechniques[currentTechniqueIndex]['duration'];
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          // Move to the next technique
          if (currentTechniqueIndex < pranayamaTechniques.length - 1) {
            currentTechniqueIndex++;
            timerSeconds =
                pranayamaTechniques[currentTechniqueIndex]['duration'];
            playTransitionSound();
          } else {
            timer.cancel(); // Stop the timer when all techniques are done
            showWorkoutCompleteDialog('Pranayama');
          }
        }
      });
    });
  }

  void playTransitionSound() async {
    await audioPlayer.play(AssetSource(
        'sounds/transition_sound.mp3')); // Add a sound file to your assets
  }

  @override
  void dispose() {
    timer.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pranayama Routine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Technique: ${pranayamaTechniques[currentTechniqueIndex]['name']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Time Remaining: ${timerSeconds ~/ 60}:${(timerSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Optionally add a pause/resume feature
              },
              child: Text('Pause'),
            ),
          ],
        ),
      ),
    );
  }
}
