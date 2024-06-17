import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/views/history_detail.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.duration,
    required this.errorTotalCount,
    required this.specificErrorFrames,
  });

  final String title;
  final String imageUrl;
  final Timestamp date;
  final int duration;
  final int errorTotalCount;
  final List specificErrorFrames;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HistoryDetail(
            title: title,
            imageUrl: imageUrl,
            date: date,
            duration: duration,
            errorTotalCount: errorTotalCount,
            specificErrorFrames: specificErrorFrames,
          );
        }));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    imageUrl,
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date.toDate().toString().substring(0, 19),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_sharp,
                            size: 16.0,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4.0),
                          Text(duration.toString()),
                          const SizedBox(width: 16.0),
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4.0),
                          Text(errorTotalCount.toString()),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.1,
          ),
        ],
      ),
    );
  }
}
