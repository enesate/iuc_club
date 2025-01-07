import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Duyuru oluştur
  Future<void> createAnnouncement({
    required String clubId,
    required String title,
    required String message,
    List<String>? recipients,
    String? eventId,
  }) async {
    try {
      await _firestore.collection('announcements').add({
        'clubId': clubId,
        'eventId': eventId,
        'title': title,
        'message': message,
        'recipients': recipients ?? [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Duyuru oluşturulamadı: $e');
    }
  }

  // Kulübe ait duyuruları getir
  Future<List<Map<String, dynamic>>> getAnnouncementsByClubId(String clubId) async {
    final snapshot = await _firestore.collection('announcements').where('clubId', isEqualTo: clubId).orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
