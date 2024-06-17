import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_excercise_correction/services/histories_service.dart';

import '../widgets/history_item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoriesService _historiesService = HistoriesService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your exercise history',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _historiesService
                    .getHistoriesByUserID(_auth.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int historyCount = snapshot.data!.docs.length;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.fire,
                            size: 24.0,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'You have exercised $historyCount times.',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _historiesService
                    .getHistoriesByUserID(_auth.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<HistoryItem> historyItems =
                        snapshot.data!.docs.map((doc) {
                      return HistoryItem(
                        title: doc['ExcerciseName'],
                        imageUrl:
                            './assets/images/${doc['ExcerciseName'].toString().toLowerCase()}.webp',
                        date: doc['Datetime'],
                        duration: doc['Duration'],
                        errorTotalCount: doc['ErrorTotalCount'],
                        specificErrorFrames: doc['SpecificErrorFrames'],
                      );
                    }).toList();
                    return Column(
                      children: historyItems.map((item) {
                        return HistoryItem(
                          title: item.title,
                          imageUrl: item.imageUrl,
                          date: item.date,
                          duration: item.duration,
                          errorTotalCount: item.errorTotalCount,
                          specificErrorFrames: item.specificErrorFrames,
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
