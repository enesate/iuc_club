import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iuc_club/data/models/event_model.dart';
import 'package:iuc_club/data/models/user_model.dart';

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcının üye olduğu kulüplerin etkinliklerini getir
  Future<List<EventModel>> getEventsForUserClubs(List<String> clubIds) async {
    if (clubIds.isEmpty) return [];
    final snapshot = await _firestore.collection('events').where('clubId', whereIn: clubIds).orderBy('date').get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  //kullanıcının katıldığı etkinlikleri getir
  Future<List<EventModel>> getUserEvents(String userId) async {
    final snapshot = await _firestore.collection('events').where('participants', arrayContains: userId).get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  // Tüm etkinlikleri getir
  Future<List<EventModel>> getAllEvents() async {
    final snapshot = await _firestore.collection('events').orderBy('date').get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  // Kullanıcının bir etkinliğe katılması
  Future<void> joinEvent(String eventId, String userId) async {
    await _firestore.collection('events').doc(eventId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  // Kullanıcıyı kulübe üye yap
  Future<void> joinClub(String clubId, String userId) async {
    try {
      // Kulübün `members` listesine kullanıcı ekle
      await _firestore.collection('clubs').doc(clubId).update({
        'members': FieldValue.arrayUnion([userId]),
      });

      // Kullanıcının `clubIds` listesine kulüp ekle
      await _firestore.collection('users').doc(userId).update({
        'clubIds': FieldValue.arrayUnion([clubId]),
      });
    } catch (e) {
      throw Exception('Kulübe üye olma işlemi başarısız: $e');
    }
  }

  // Etkinlik oluştur
  Future<void> createEvent(EventModel event) async {
    try {
      String uniqueId = _firestore.collection('events').doc().id;
      event = event.copyWith(id: uniqueId);
      await _firestore.collection('events').doc(event.id).set(event.toJson());
    } catch (e) {
      throw Exception('Etkinlik oluşturulamadı: $e');
    }
  }

  // Etkinliği güncelle
  Future<void> updateEvent(EventModel event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toJson());
    } catch (e) {
      throw Exception('Etkinlik güncellenemedi: $e');
    }
  }

  // Etkinliği sil
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Etkinlik silinemedi: $e');
    }
  }

  // Etkinlikleri getir
  Future<List<EventModel>> getEventsByClubId(String clubId) async {
    final snapshot = await _firestore.collection('events').where('clubId', isEqualTo: clubId).orderBy('date').get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  //etkinliklerdeki katılımcıları  usermodel getir
  Future<List<UserModel>> getEventParticipants(List<String> participantIds) async {
    final snapshot = await _firestore.collection('users').where('id', whereIn: participantIds).get();
    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }
}
