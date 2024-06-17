import 'package:cloud_firestore/cloud_firestore.dart';

class HistoriesCheckService {
  final CollectionReference historiesCheckCollection =
      FirebaseFirestore.instance.collection('HandledOfflineVideos');

  Stream<QuerySnapshot> getHistoriesCheckedByUserID(
      String userId, String exerciseType) {
    return historiesCheckCollection
        .where('UserId', isEqualTo: userId)
        .where('ExerciseType', isEqualTo: exerciseType)
        .orderBy('UploadedAt', descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>> getErrorDetailsByID(String id) async {
    DocumentSnapshot docSnapshot = await historiesCheckCollection.doc(id).get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      Map<String, dynamic> errorDetails =
          docSnapshot.data() as Map<String, dynamic>;
      print(errorDetails['ErrorDetails']);
      return errorDetails['ErrorDetails'];
    } else {
      return {}; // Trả về một Map rỗng nếu không tìm thấy document hoặc không có dữ liệu
    }
  }
}
