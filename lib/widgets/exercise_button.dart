import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/services/histories_service.dart';
import 'package:gym_excercise_correction/views/exercise_detail.dart';
import 'package:intl/intl.dart';

class ExerciseButton extends StatefulWidget {
  ExerciseButton({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  final String imageUrl;
  final String title;

  @override
  State<ExerciseButton> createState() => _ExerciseButtonState();
}

String extra_title(String title) {
  List<String> new_title = [];
  String result = '';
  new_title = title.split(' ');
  if (new_title.isNotEmpty) {
    result = new_title[0][0] + new_title[0].substring(1).toLowerCase();
  }
  if (new_title.length > 1) {
    result += ' ${new_title[1][0]}${new_title[1].substring(1).toLowerCase()}';
  }
  return result;
}

class _ExerciseButtonState extends State<ExerciseButton> {
  String lastTime = DateTime.now.toString();
  User user = FirebaseAuth.instance.currentUser!;
  @override
  initState() {
    super.initState();
    HistoriesService()
        .getLastDateTimeByUserIDExerciseName(
            user.uid, extra_title(widget.title))
        .then((value) {
      setState(() {
        lastTime = DateFormat('MMM d, y').format(value);
        if (lastTime == 'Jan 1, 0') {
          lastTime = 'Never';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ExerciseDetail(
            title: widget.title,
            imageUrl: widget.imageUrl,
          );
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
          image: DecorationImage(
              image: AssetImage(widget.imageUrl), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Last time:${lastTime == null ? 'Never' : lastTime.toString()}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
