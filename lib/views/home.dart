import 'package:flutter/material.dart';

import '../widgets/exercise_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Gym Exercise Correction',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '15',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('WORKOUTS'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '104',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('MINUTES'),
                      ],
                    ),
                  ],
                ),
                ExerciseButton(
                  imageUrl: './assets/images/plank.webp',
                  title: 'PLANK',
                ),
                ExerciseButton(
                  imageUrl: './assets/images/squat.webp',
                  title: 'SQUAT',
                ),
                ExerciseButton(
                  imageUrl: './assets/images/bicep_curl.webp',
                  title: 'BICEP CURL',
                ),
                ExerciseButton(
                  imageUrl: './assets/images/lunge.webp',
                  title: 'LUNGES',
                ),
                ExerciseButton(
                  imageUrl: './assets/images/push_up.webp',
                  title: 'PUSH UP',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
