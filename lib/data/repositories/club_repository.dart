import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iuc_club/data/models/user_model.dart';

class ClubRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kulüp üyelerinin FCM tokenlarını getir
  Future<List<String>> getClubMemberTokens(String clubId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('clubIds', arrayContains: clubId) // clubIds içinde clubId olan kullanıcılar
          .get();

      // FCM tokenlarını al
      List<String> tokens = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['fcmToken'] != null) {
          tokens.add(data['fcmToken']);
        }
      }
      return tokens;
    } catch (e) {
      throw Exception('Kulüp üyeleri alınırken bir hata oluştu: $e');
    }
  }

  // Kulübün üyelerini getir ve üyelerin id lerini users koleksiyondan bul userlarını getir
  /* Future<List<Map<String, dynamic>>> getClubMembers(String clubId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('clubIds', arrayContains: clubId) // clubIds içinde clubId olan kullanıcılar
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Kulüp üyeleri alınırken bir hata oluştu: $e');
    }
  } */

  Future<List<UserModel>> getClubMembers(String clubId) async {
    try {
      final doc = await _firestore.collection('clubs').doc(clubId).get();
      if (doc.exists) {
        final data = doc.data()!;
        final memberIds = List<String>.from(data['members'] ?? []);
        final memberDocs = await Future.wait(memberIds.map((id) => _firestore.collection('users').doc(id).get()));
        return memberDocs.map((doc) => UserModel.fromJson(doc.data()!)).toList();
        //return List<String>.from(data['members'] ?? []);
      }
      return [];
    } catch (e) {
      throw Exception('Kulüp üyeleri alınırken bir hata oluştu: $e');
    }
  }

  // Kulüp üyelik başvurularını getir
  Future<List<Map<String, dynamic>>> getClubApplications(String clubId) async {
    try {
      final snapshot = await _firestore
          .collection('applications')
          .where('clubId', isEqualTo: clubId)
          .where('status', isEqualTo: 'pending') // Sadece bekleyen başvurular
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Başvurular alınırken bir hata oluştu: $e');
    }
  }

  // Üyelik başvurusunu onayla
  Future<void> approveApplication(String applicationId, String clubId, String userId) async {
    try {
      // Başvuru durumunu güncelle
      await _firestore.collection('applications').doc(applicationId).update({
        'status': 'approved',
      });

      // Kullanıcıyı kulübün üyeleri arasına ekle
      await _firestore.collection('clubs').doc(clubId).update({
        'members': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Başvuru onaylanırken bir hata oluştu: $e');
    }
  }

  // Üyelik başvurusunu reddet
  Future<void> rejectApplication(String applicationId) async {
    try {
      await _firestore.collection('applications').doc(applicationId).update({
        'status': 'rejected',
      });
    } catch (e) {
      throw Exception('Başvuru reddedilirken bir hata oluştu: $e');
    }
  }
}
