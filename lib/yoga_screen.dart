import 'package:fitness_tracker/workout_screen.dart';
import 'package:flutter/material.dart';

class YogaScreen extends WorkoutScreen {
  const YogaScreen({Key? key}) : super(key: key);

  @override
  _YogaScreenState createState() => _YogaScreenState();
}

class _YogaScreenState extends WorkoutScreenState<YogaScreen> {
  _YogaScreenState()
      : super(exercises: [
          {
            'name': 'Downward Dog',
            'duration': 120,
            'image': 'assets/images/upper/VUp.gif'
          },
          {
            'name': 'Seated Forward Bend',
            'duration': 120,
            'image': 'assets/images/upper/Plank_Ups.gif'
          },
          {
            'name': 'Cobblers Pose',
            'duration': 120,
            'image': 'assets/images/upper/VUp.gif'
          },
          {
            'name': 'Bridge Pose',
            'duration': 120,
            'image': 'assets/images/meditation_image.jpg'
          },
          {
            'name': 'Shoulder stand',
            'duration': 180,
            'image': 'assets/images/meditation_image.jpg'
          },
          {
            'name': 'Shavasana (corpse)',
            'duration': 180,
            'image': 'assets/images/meditation_image.jpg'
          },
        ], sets: 1, workoutName: 'Yoga', restDuration: 0);
}
