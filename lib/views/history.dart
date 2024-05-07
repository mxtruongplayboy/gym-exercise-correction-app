import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/history_item.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 242, 248, 253),
                  ),
                  child: const Text(
                    'Weekly Summary',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const HistoryItem(
                  title: 'Plank',
                  imageUrl: './assets/images/plank.webp',
                ),
                const HistoryItem(
                  title: 'Lunge',
                  imageUrl: './assets/images/lunge.webp',
                ),
                const HistoryItem(
                  title: 'Squat',
                  imageUrl: './assets/images/squat.webp',
                ),
                const HistoryItem(
                  title: 'Bicep curl',
                  imageUrl: './assets/images/bicep_curl.webp',
                ),
                const HistoryItem(
                  title: 'Bicep curl',
                  imageUrl: './assets/images/bicep_curl.webp',
                ),
                const HistoryItem(
                  title: 'Push up',
                  imageUrl: './assets/images/push_up.webp',
                ),
                const HistoryItem(
                  title: 'Plank',
                  imageUrl: './assets/images/plank.webp',
                ),
                const HistoryItem(
                  title: 'Push up',
                  imageUrl: './assets/images/push_up.webp',
                ),
                const HistoryItem(
                  title: 'Plank',
                  imageUrl: './assets/images/plank.webp',
                ),
                const HistoryItem(
                  title: 'Push up',
                  imageUrl: './assets/images/push_up.webp',
                ),
              ],
            ),
          )),
    );
  }
}
