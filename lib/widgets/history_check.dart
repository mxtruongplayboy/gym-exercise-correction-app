import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_excercise_correction/services/histories_check_service.dart';

import 'history_check_item.dart';

class HistoryCheck extends StatefulWidget {
  const HistoryCheck({super.key, required this.title});

  final String title;

  @override
  State<HistoryCheck> createState() => _HistoryCheckState();
}

class _HistoryCheckState extends State<HistoryCheck> {
  final HistoriesCheckService historiesCheckService = HistoriesCheckService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: historiesCheckService.getHistoriesCheckedByUserID(
                  _auth.currentUser!.uid,
                  widget.title.toLowerCase().split(' ').join('_')),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<HistoryCheckItem> historyCheckItems =
                      snapshot.data!.docs.map((doc) {
                    int i = 0;
                    String thumbNail = '';
                    if (doc.data().toString().contains('ErrorDetails')) {
                      for (var item in doc['ErrorDetails'].keys.toList()) {
                        if (thumbNail == '') {
                          thumbNail = doc['ErrorDetails'][item][0]['url'];
                        }
                        for (var error in doc['ErrorDetails'][item]) {
                          i++;
                        }
                      }
                    }

                    if (thumbNail == '') {
                      thumbNail =
                          'https://cdn-icons-png.freepik.com/512/4471/4471883.png';
                    }
                    return HistoryCheckItem(
                      title: doc['ExerciseType'],
                      imageUrl: thumbNail,
                      date: doc['UploadedAt'],
                      handledVideoUrl: doc['HandledVideoUrl'],
                      id: doc.id,
                      error: i.toString(),
                    );
                  }).toList();
                  return Column(
                    children: historyCheckItems.map((item) {
                      return HistoryCheckItem(
                        title: item.title,
                        imageUrl: item.imageUrl,
                        date: item.date,
                        handledVideoUrl: item.handledVideoUrl,
                        id: item.id,
                        error: item.error,
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      )),
    );
  }
}
