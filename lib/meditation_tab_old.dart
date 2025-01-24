import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // For playing sounds
import '../database_helper.dart';

class MeditationTab extends StatefulWidget {
  @override
  _MeditationTabState createState() => _MeditationTabState();
}

class _MeditationTabState extends State<MeditationTab> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMeditating = false;
  DateTime? _startTime;
  int _durationInSeconds = 0;
  int _selectedDuration = 1; // Default duration (1 minute)
  String _statusMessage = 'Select Duration and Start Meditation';

  void _startMeditation() {
    setState(() {
      _isMeditating = true;
      _startTime = DateTime.now();
      _durationInSeconds = _selectedDuration * 60; // Convert minutes to seconds
      _statusMessage = 'Relax your body and focus on your breath.';
    });

    // Update the timer every second
    Future.delayed(Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer() {
    if (_isMeditating && _durationInSeconds > 0) {
      setState(() {
        _durationInSeconds--;
      });
      Future.delayed(Duration(seconds: 1), _updateTimer);
    } else if (_isMeditating) {
      _endMeditation();
    }
  }

  void _endMeditation() async {
    setState(() {
      _isMeditating = false;
      _statusMessage = 'Meditation Complete!';
    });

    // Play stop sound
    await _audioPlayer.play(AssetSource('sounds/rest_sound.mp3'));

    // Log the meditation session
    final date = DateTime.now().toIso8601String().split('T').first;
    final durationInMinutes =
        (_selectedDuration * 60 - _durationInSeconds) ~/ 60;
    DatabaseHelper().logScore(date, 'Meditation', 20);
    DatabaseHelper().logMeditation(date, durationInMinutes);
  }

  void _stopMeditation() async {
    setState(() {
      _isMeditating = false;
      _statusMessage = 'Meditation Stopped.';
    });

    // Log the meditation session
    final date = DateTime.now().toIso8601String().split('T').first;
    final durationInMinutes =
        (_selectedDuration * 60 - _durationInSeconds) ~/ 60;
    DatabaseHelper().logScore(date, 'Meditation', 20);
    DatabaseHelper().logMeditation(date, durationInMinutes);
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (_isMeditating)
            Image.asset(
              'assets/images/meditation_image.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          SizedBox(height: 20),
          Text(
            _statusMessage,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Time Remaining: ${_formatDuration(_durationInSeconds)}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          if (!_isMeditating)
            Wrap(
              spacing: 10,
              children: [1, 3, 5, 10, 30, 45].map((duration) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDuration = duration;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedDuration == duration
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text('$duration min'),
                );
              }).toList(),
            ),
          SizedBox(height: 20),
          if (!_isMeditating)
            ElevatedButton(
              onPressed: _startMeditation,
              child: Text('Start Meditation'),
            ),
          if (_isMeditating)
            ElevatedButton(
              onPressed: _stopMeditation,
              child: Text('Stop Meditation'),
            ),
        ],
      ),
    );
  }
}
