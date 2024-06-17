import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/exercise_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  User user = FirebaseAuth.instance.currentUser!;

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${user.email!.split('@').first}',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
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
                  imageUrl: './assets/images/bicep curl.webp',
                  title: 'BICEP CURL',
                ),
                 ExerciseButton(
                  imageUrl: './assets/images/lunge.webp',
                  title: 'LUNGE',
                ),
                 ExerciseButton(
                  imageUrl: './assets/images/push up.webp',
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
