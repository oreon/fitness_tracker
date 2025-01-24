import 'package:fitness_tracker/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class YogaScreen extends WorkoutScreen {
  const YogaScreen({Key? key}) : super(key: key);

  @override
  _YogaScreenState createState() => _YogaScreenState();
}

class _YogaScreenState extends WorkoutScreenState<YogaScreen> {
  final List<Map<String, dynamic>> asanas = [
    {
      'name': 'Downward Dog',
      'image':
          'https://liforme.com/cdn/shop/articles/Downward_Facing_Dog_-_Adho_Mukha_Svanasana_12_Happiness.webp?v=1712603374&width=1920',
    },
    {
      'name': 'Paschimottanasana (Seated Forward Bend)',
      'image':
          'https://www.arhantayoga.org/wp-content/uploads/2022/03/Seated-Forward-Bend-%E2%80%93-Paschimottanasana.jpg',
    },
    {
      'name': 'Cobblers Pose',
      'image':
          'https://www.pinkvilla.com/images/2024-02/1708957217_select-2024-02-26t195006-960.jpg',
    },
    {
      'name': 'Seated Twist',
      'image':
          'https://www.yogaclassplan.com/wp-content/uploads/2021/06/18-halflord-fishes.jpg',
    },
    {
      'name': 'Setubandha Asana (Bridge)',
      'image':
          'https://www.yogaclassplan.com/wp-content/uploads/2021/06/bridgepose-1.png'
    },
    {
      'name': 'Shoulder Stand',
      'image':
          'https://www.yogaclassplan.com/wp-content/uploads/2021/06/supported-shoulderstand.png',
    },
    {
      'name': 'Cobra Pose',
      'image':
          'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    },
    {
      'name': 'Shavasana',
      'image':
          'https://www.yogaclassplan.com/wp-content/uploads/2021/06/13-corpse-pose.jpg',
    },
  ];

  int currentAsanaIndex = 0;
  int timerSeconds = 120; // 2 minutes for each asana
  late Timer timer;
  bool isPaused = false; // Track whether the timer is paused
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          if (timerSeconds > 0) {
            timerSeconds--;
          } else {
            // Move to the next asana
            if (currentAsanaIndex < asanas.length - 1) {
              currentAsanaIndex++;
              timerSeconds = 120; // Reset timer for the next asana
              playTransitionSound();
            } else {
              timer.cancel(); // Stop the timer when all asanas are done
              showWorkoutCompleteDialog('Yoga');
            }
          }
        });
      }
    });
  }

  void playTransitionSound() async {
    await audioPlayer.play(AssetSource(
        'sounds/transition_sound.mp3')); // Add a sound file to your assets
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused; // Toggle pause state
    });
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
        title: Text('Yoga Routine'),
      ),
      body: Column(
        children: [
          // Full-width image with good height
          Container(
            width: double.infinity, // Full screen width
            height: MediaQuery.of(context).size.height *
                0.4, // 40% of screen height
            child: Image.network(
              asanas[currentAsanaIndex]['image'],
              fit: BoxFit.cover, // Scale the image to cover the container
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.error, size: 50, color: Colors.red),
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Asana: ${asanas[currentAsanaIndex]['name']}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Time Remaining: ${timerSeconds ~/ 60}:${(timerSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: togglePause, // Toggle pause/resume
                    child: Text(isPaused ? 'Resume' : 'Pause'),
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
