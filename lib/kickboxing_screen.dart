import 'package:fitness_tracker/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class KickboxingScreen extends WorkoutScreen {
  const KickboxingScreen({Key? key}) : super(key: key);

  @override
  _KickboxingScreenState createState() => _KickboxingScreenState();
}

class _KickboxingScreenState extends WorkoutScreenState<KickboxingScreen> {
  final List<Map<String, dynamic>> combos = [
    {'name': 'Jab, Cross, Lead Hook', 'duration': 120}, // 2 minutes
    {'name': 'Front Kick, Side Kick, Elbow', 'duration': 120}, // 2 minutes
    {'name': 'Jab, Cross, Low Kick', 'duration': 180}, // 3 minutes
    {'name': 'Front Kick, Side Kick, Back Kick', 'duration': 180}, // 3 minutes
  ];

  int currentComboIndex = 0;
  int timerSeconds = 0;
  bool isRestPeriod = false;
  late Timer timer;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    timerSeconds = combos[currentComboIndex]['duration'];
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          if (isRestPeriod) {
            // Move to the next combo
            if (currentComboIndex < combos.length - 1) {
              currentComboIndex++;
              timerSeconds = combos[currentComboIndex]['duration'];
              isRestPeriod = false;
              playTransitionSound();
            } else {
              timer.cancel(); // Stop the timer when all combos are done
              showWorkoutCompleteDialog('KickBoxing');
            }
          } else {
            // Start 1-minute rest period
            timerSeconds = 60; // 1 minute rest
            isRestPeriod = true;
            playTransitionSound();
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
        title: Text('Kickboxing Routine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isRestPeriod
                  ? 'Rest Period'
                  : 'Current Combo: ${combos[currentComboIndex]['name']}',
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
