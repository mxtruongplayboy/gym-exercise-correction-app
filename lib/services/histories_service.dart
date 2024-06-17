import 'package:cloud_firestore/cloud_firestore.dart';

class HistoriesService {
  final CollectionReference introductionCollection =
      FirebaseFirestore.instance.collection('Histories');

  Stream<QuerySnapshot> getHistoriesByUserID(String UserID) {
    return introductionCollection
        .where('UserID', isEqualTo: UserID)
        .orderBy('Datetime', descending: true)
        .snapshots();
  }

  Future<DateTime> getLastDateTimeByUserIDExerciseName(
      String userID, String exerciseName) async {
    try {
      final querySnapshot = await introductionCollection
          .where('UserID', isEqualTo: userID)
          .where('ExcerciseName', isEqualTo: exerciseName)
          .orderBy('Datetime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lấy giá trị trường 'Datetime' từ snapshot
        final timestamp = querySnapshot.docs.first['Datetime'];
        // Chuyển đổi timestamp thành DateTime
        return (timestamp as Timestamp).toDate();
      } else {
        // Nếu không có dữ liệu, trả về null
        return DateTime(0);
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Error getting last DateTime: $e");
      return DateTime(0);
    }
  }
}
