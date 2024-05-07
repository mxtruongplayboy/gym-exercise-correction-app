import 'package:cloud_firestore/cloud_firestore.dart';

class IntroductionService {
  final CollectionReference introductionCollection =
      FirebaseFirestore.instance.collection('Introductions');

  // Hàm này trả về một Stream của QuerySnapshot cho tất cả giới thiệu
  Stream<QuerySnapshot> get introduction {
    return introductionCollection.snapshots();
  }

  // Thêm phương thức này để lấy các tài liệu theo Name
  Stream<QuerySnapshot> getIntroductionByName(String name) {
    return introductionCollection.where('Name', isEqualTo: name).snapshots();
  }
}
