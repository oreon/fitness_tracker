import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'database_helper.dart'; // Import the DatabaseHelper class

abstract class MeditationScreen extends StatefulWidget {
  final String audioFile; // Audio file for the meditation
  final String meditationName; // Name of the meditation

  const MeditationScreen({
    Key? key,
    required this.audioFile,
    required this.meditationName,
  }) : super(key: key);
}

abstract class MeditationScreenState<T extends MeditationScreen>
    extends State<T> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<int> durations = [1, 5, 10, 15, 30, 45]; // Durations in minutes
  int? selectedDuration; // Selected duration in minutes
  int timerSeconds = 0; // Timer in seconds
  bool isPlaying = false;
  bool isPaused = false;
  late Timer timer;

  @override
  void dispose() {
    audioPlayer.dispose(); // Release resources
    timer.cancel(); // Cancel the timer
    super.dispose();
  }

  Future<void> startMeditation() async {
    if (selectedDuration == null) return; // No duration selected

    await audioPlayer
        .play(AssetSource(widget.audioFile)); // Play the audio file
    setState(() {
      isPlaying = true;
      isPaused = false;
      timerSeconds = selectedDuration! * 60; // Convert minutes to seconds
    });

    // Start the timer
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          timer.cancel(); // Stop the timer when it reaches 0
          endMeditation();
        }
      });
    });
  }

  Future<void> pauseMeditation() async {
    await audioPlayer.pause(); // Pause the audio
    setState(() {
      isPaused = true;
    });
  }

  Future<void> resumeMeditation() async {
    await audioPlayer.resume(); // Resume the audio
    setState(() {
      isPaused = false;
    });
  }

  Future<void> endMeditation() async {
    await audioPlayer.stop(); // Stop the audio
    timer.cancel(); // Cancel the timer
    setState(() {
      isPlaying = false;
      isPaused = false;
    });

    // Log the meditation session
    await _logMeditation();
  }

  Future<void> _logMeditation() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.logActivity(
        widget.meditationName, (selectedDuration! * 60) - timerSeconds, '');
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meditationName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isPlaying)
              Column(
                children: [
                  Text(
                    'Select Duration (minutes):',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: durations.map((duration) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration = duration;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedDuration == duration ? Colors.blue : null,
                        ),
                        child: Text('$duration'),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        selectedDuration != null ? startMeditation : null,
                    child: Text('Start Meditation'),
                  ),
                ],
              ),
            if (isPlaying)
              Column(
                children: [
                  Text(
                    'Time Remaining: ${timerSeconds ~/ 60}:${(timerSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (!isPaused)
                    ElevatedButton(
                      onPressed: pauseMeditation,
                      child: Text('Pause Meditation'),
                    ),
                  if (isPaused)
                    ElevatedButton(
                      onPressed: resumeMeditation,
                      child: Text('Resume Meditation'),
                    ),
                  ElevatedButton(
                    onPressed: endMeditation,
                    child: Text('End Meditation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
