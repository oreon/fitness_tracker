import 'package:fitness_tracker/meditation_screen.dart';
import 'package:flutter/material.dart';

class BreathMeditationScreen extends MeditationScreen {
  const BreathMeditationScreen({Key? key})
      : super(
          key: key,
          audioFile: 'sounds/3_min_breath.mp3',
          meditationName: 'Breath Meditation',
        );

  @override
  State<BreathMeditationScreen> createState() => _BreathMeditationScreenState();
}

class _BreathMeditationScreenState
    extends MeditationScreenState<BreathMeditationScreen> {
  // Add any specific state logic for Breath Meditation here
}

class BodyScanScreen extends MeditationScreen {
  const BodyScanScreen({Key? key})
      : super(
          key: key,
          audioFile: 'sounds/relax.mp3',
          meditationName: 'Body Scan',
        );

  @override
  State<BodyScanScreen> createState() => _BodyScanScreenState();
}

class _BodyScanScreenState extends MeditationScreenState<BodyScanScreen> {
  // Add any specific state logic for Body Scan here
}

class EatingMeditationScreen extends MeditationScreen {
  const EatingMeditationScreen({Key? key})
      : super(
          key: key,
          audioFile: 'sounds/pre-meals.mp3',
          meditationName: 'Eating Meditation',
        );

  @override
  State<EatingMeditationScreen> createState() => _EatingMeditationScreenState();
}

class _EatingMeditationScreenState
    extends MeditationScreenState<EatingMeditationScreen> {
  // Add any specific state logic for Eating Meditation here
}

class WalkingMeditationScreen extends MeditationScreen {
  const WalkingMeditationScreen({Key? key})
      : super(
          key: key,
          audioFile: 'sounds/relax.mp3',
          meditationName: 'Walking Meditation',
        );

  @override
  State<WalkingMeditationScreen> createState() =>
      _WalkingMeditationScreenState();
}

class _WalkingMeditationScreenState
    extends MeditationScreenState<WalkingMeditationScreen> {
  // Add any specific state logic for Walking Meditation here
}
