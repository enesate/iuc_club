import 'package:get/get.dart';
import 'package:iuc_club/data/datasources/notification_service.dart';
import 'package:iuc_club/data/repositories/annoucement_repository.dart';
import 'package:iuc_club/data/repositories/club_repository.dart';

class AnnouncementController extends GetxController {
  final ClubRepository clubRepository;
  final AnnouncementRepository announcementRepository;
  final NotificationService notificationService;

  var announcements = <Map<String, dynamic>>[].obs; // Duyurular
  var isLoading = true.obs;

  AnnouncementController(
    this.clubRepository,
    this.announcementRepository,
    this.notificationService,
  );

  // Kulübe ait duyuruları yükle
  Future<void> loadAnnouncements(String clubId) async {
    isLoading.value = true;
    try {
      announcements.value = await announcementRepository.getAnnouncementsByClubId(clubId);
    } catch (e) {
      Get.snackbar('Hata', 'Duyurular yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Duyuru oluştur ve bildirim gönder
  Future<void> createAnnouncement({
    required String clubId,
    required String title,
    required String message,
  }) async {
    isLoading.value = true;
    try {
      // Kulüp üyelerinin FCM tokenlarını al
      final tokens = await clubRepository.getClubMemberTokens(clubId);

      // Duyuruyu Firestore'a kaydet
      await announcementRepository.createAnnouncement(
        clubId: clubId,
        title: title,
        message: message,
        recipients: tokens,
      );

      // Bildirim gönder
      if (tokens.isNotEmpty) {
        await notificationService.sendNotification(
          tokens: tokens,
          title: title,
          body: message,
        );
      }
      loadAnnouncements(clubId);
      Get.snackbar('Başarılı', 'Duyuru oluşturuldu ve bildirim gönderildi.');
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
