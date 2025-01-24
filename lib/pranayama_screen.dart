import 'package:fitness_tracker/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PranayamaScreen extends WorkoutScreen {
  const PranayamaScreen({Key? key}) : super(key: key);

  @override
  _PranayamaScreenState createState() => _PranayamaScreenState();
}

class _PranayamaScreenState extends WorkoutScreenState<PranayamaScreen> {
  _PranayamaScreenState()
      : super(exercises: [
          {
            'name': 'Bhastrika',
            'duration': 18,
            'image': 'assets/images/meditation_image.jpg'
          },
          {
            'name': 'Kapalbhati',
            'duration': 30,
            'image': 'assets/images/meditation_image.jpg'
          },
          {
            'name': 'Nadi Shodhan',
            'duration': 42,
            'image': 'assets/images/meditation_image.jpg'
          },
          {
            'name': 'Bhramari',
            'duration': 12,
            'image': 'assets/images/bhramarimeditation_image.jpg'
          },
          {
            'name': 'Ujjayi',
            'duration': 18,
            'image': 'assets/images/meditation_image.jpg'
          },
        ], sets: 1, workoutName: 'Pranayama', restDuration: 0);
}
