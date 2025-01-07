import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iuc_club/data/models/club_model.dart';
import 'package:iuc_club/data/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı kayıt ol
  Future<User?> registerUser({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // Firebase Auth ile kullanıcı oluştur
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Kullanıcı Firestore'a kaydedilir
      if (user != null) {
        final fcmToken = await FirebaseMessaging.instance.getToken();

        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': name,
          'email': email,
          'role': role, // Kullanıcı rolü: student, president, advisor
          'clubIds': [], // Kullanıcının ait olduğu kulüpler
          'fcmToken': fcmToken, // Bildirimler için Firebase cihaz tokenı
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Kayıt başarısız.');
    }
  }

  // Kullanıcı giriş yap
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Firebase Auth ile giriş yap
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // FCM token güncelle
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _firestore.collection('users').doc(userId).update({
          'fcmToken': fcmToken,
        });
      }

      // Kullanıcı bilgilerini Firestore'dan getir
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('Kullanıcı bulunamadı.');
      }

      return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Giriş başarısız.');
    }
  }

  // Kullanıcı çıkış yap
  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  void setupFcmTokenListener(String userId) {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      try {
        // Yeni token Firestore'da güncellenir
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'fcmToken': newToken,
        });
        print('FCM Token yenilendi ve güncellendi: $newToken');
      } catch (e) {
        print('FCM Token güncellenemedi: $e');
      }
    });
  }

  //all clubs gets presdinet id == user id  get clubs equal presdien id get 1 club
  Future<ClubModel?> getClubsByPresident(String presidentId) async {
    final snapshot = await _firestore.collection('clubs').where('presidentId', isEqualTo: presidentId).get();
    if (snapshot.docs.isNotEmpty) {
      return ClubModel.fromJson(snapshot.docs.first.data());
    } else {
      print('Kulüp bulunamadı.');
      return null;
    }
  }

  /* // Kullanıcı giriş işlemi
  Future<void> login(String email, String password, String role) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Firebase Firestore'dan kullanıcı rolünü kontrol et
      final userRole = await _getUserRole(user.user!.uid);
      if (userRole != role) {
        Get.snackbar("Hata", "Yanlış kullanıcı türü seçildi.");
        return;
      }

      Get.offAllNamed('/${role}_home'); // Rolüne göre ana sayfaya yönlendir
    } catch (e) {
      Get.snackbar("Hata", "Giriş yapılamadı: $e");
    }
  }

  // Kullanıcı rolünü Firestore'dan al
  Future<String> _getUserRole(String userId) async {
    // Firestore sorgusu (örnek koleksiyon adı: users)
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data()?['role'] ?? 'student';
  }

  // Danışman hoca kulüp başkanı ataması
  Future<void> assignClubPresident(String email, String clubId) async {
    try {
      // Firebase'de kulüp başkanını kulüp kaydına ekle
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isEmpty) {
        Get.snackbar("Hata", "Bu e-posta adresine sahip bir kullanıcı bulunamadı.");
        return;
      }

      final userId = userDoc.docs.first.id;

      await FirebaseFirestore.instance.collection('clubs').doc(clubId).update({
        'presidentId': userId,
      });

      Get.snackbar("Başarılı", "Kulüp başkanı atanmıştır.");
    } catch (e) {
      Get.snackbar("Hata", "Atama yapılamadı: $e");
    }
  } */
}
