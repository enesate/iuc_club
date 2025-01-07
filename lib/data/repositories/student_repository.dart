import 'package:cloud_firestore/cloud_firestore.dart';

class StudentRepository {
  //final _firestore = FirebaseFirestore.instance;

  /* Future<List<Map<String, dynamic>>> getStudentEvents(String userId) async {
    try {
      final snapshot = await _firestore.collection('events').where('participants', arrayContains: userId).get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  } */

  /* Future<bool> isUserClubMember(String userId, String clubId) async {
    final doc = await _firestore.collection('clubs').doc(clubId).get();
    return (doc.data()?['members'] as List<dynamic>).contains(userId);
  }

  Future<void> addUserToClub(String userId, String clubId) async {
    await _firestore.collection('clubs').doc(clubId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> addUserToEvent(String userId, String eventId) async {
    await _firestore.collection('events').doc(eventId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  } */
}
