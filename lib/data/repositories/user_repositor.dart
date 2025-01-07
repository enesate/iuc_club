import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  /* final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data() ?? {};
  }

  Future<List<Map<String, dynamic>>> fetchUserClubs(String userId) async {
    final snapshot = await _firestore
        .collection('clubs')
        .where('members', arrayContains: userId)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  } */

  // Birden fazla userId'ye göre kullanıcı bilgilerini getir
  /* Future<List<Map<String, dynamic>>> getUsersByIds(List<String> userIds) async {
    final userDocs = await Future.wait(userIds.map((userId) async {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    }));

    // Boş olmayan kullanıcıları filtrele ve listeye dönüştür
    return userDocs.where((doc) => doc != null).cast<Map<String, dynamic>>().toList();
  } */
}
