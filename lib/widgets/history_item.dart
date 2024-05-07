import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/views/history_detail.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HistoryDetail();
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
                      const Text(
                        'April 17, 2024, 10:00 AM',
                        style: TextStyle(
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
                      const Row(
                        children: [
                          Icon(
                            Icons.timer_sharp,
                            size: 16.0,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 4.0),
                          Text('02:00'),
                          SizedBox(width: 16.0),
                          Icon(
                            Icons.error_outline_rounded,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          SizedBox(width: 4.0),
                          Text('2'),
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
