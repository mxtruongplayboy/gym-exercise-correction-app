import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/views/history_check_detail.dart';

class HistoryCheckItem extends StatelessWidget {
  const HistoryCheckItem({
    super.key,
    required this.title,
    required this.handledVideoUrl,
    required this.date,
    required this.imageUrl,
    required this.id,
    required this.error,
  });

  final String id;
  final String title;
  final String imageUrl;
  final Timestamp date;
  final String handledVideoUrl;
  final String error;

  @override
  Widget build(BuildContext context) {
    bool isProcessing = error == '0'; // Kiểm tra nếu URL là rỗng

    return InkWell(
      onTap: isProcessing
          ? null
          : () {
              // Ngăn không cho người dùng tương tác nếu đang xử lý
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HistoryCheckDetail(
                  title: title,
                  handledVideoUrl: handledVideoUrl,
                  date: date,
                  id: id,
                );
              }));
            },
      child: Opacity(
        opacity: isProcessing ? 0.5 : 1.0, // Làm mờ item nếu đang xử lý
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        imageUrl,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date.toDate().toString().substring(0, 19),
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          if (isProcessing)
                            const Text('Đang xử lý',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic))
                          else
                            Row(
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  size: 16.0,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  error,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
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
      ),
    );
  }
}
