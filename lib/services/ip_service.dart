import 'package:cloud_firestore/cloud_firestore.dart';

class IpService {
  final CollectionReference serverInfoCollection =
      FirebaseFirestore.instance.collection('ServerInfo');

  Future<String> getFirstIP() async {
    QuerySnapshot querySnapshot = await serverInfoCollection.limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      if (doc.data() != null) {
        return doc.get('ip');
      }
      throw Exception('Field "ip" not found in the document.');
    }
    throw Exception('No documents found in ServerInfo collection.');
  }
}
