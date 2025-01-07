import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iuc_club/data/models/user_model.dart';

class AdvisorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Danışmanın kulübünü getir
  Future<Map<String, dynamic>> getAdvisorClub(String advisorId) async {
    try {
      final snapshot = await _firestore.collection('clubs').where('advisorId', isEqualTo: advisorId).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
      throw Exception('Danışmanın bağlı olduğu kulüp bulunamadı.');
    } catch (e) {
      throw Exception('Kulüp bilgileri alınırken bir hata oluştu: $e');
    }
  }

  // Kulüp etkinliklerini getir
  Future<List<Map<String, dynamic>>> getClubEvents(String clubId) async {
    try {
      final snapshot = await _firestore.collection('events').where('clubId', isEqualTo: clubId).orderBy('date').get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Etkinlikler alınırken bir hata oluştu: $e');
    }
  }

  // Kulüp başkanı atama
  Future<void> assignPresident(String clubId, String email) async {
    try {
      // Kullanıcı email ile `users` koleksiyonundan bulunur
      final snapshot = await _firestore.collection('users').where('email', isEqualTo: email).limit(1).get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Kullanıcı bulunamadı.');
      }

      final userId = snapshot.docs.first.id;

      // Kulüp belgesinde `presidentId` güncellenir
      await _firestore.collection('clubs').doc(clubId).update({
        'presidentId': userId,
      });
    } catch (e) {
      throw Exception('Kulüp başkanı atanırken bir hata oluştu: $e');
    }
  }

  // Kulüp başkanını görevden alma
  Future<void> removePresident(String clubId) async {
    try {
      // `presidentId` alanını null yap
      await _firestore.collection('clubs').doc(clubId).update({
        'presidentId': null,
      });
    } catch (e) {
      throw Exception('Başkan görevden alınırken bir hata oluştu: $e');
    }
  }

  // get usermodel with id
  Future<UserModel> getUser(String userId) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data()!);
      } else {
        throw Exception('Kullanıcı bulunamadı.');
      }
    } catch (e) {
      throw Exception('Kullanıcı bilgileri alınırken bir hata oluştu: $e');
    }
  }
}
