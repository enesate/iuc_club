import 'package:get/get.dart';
import 'package:iuc_club/data/models/user_model.dart';
import '../../data/repositories/club_repository.dart';

class MembershipRequestsController extends GetxController {
  final ClubRepository clubRepository;

  var clubMembers = <UserModel>[].obs;
  var clubApplications = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  MembershipRequestsController(this.clubRepository);

  // Kulübün üyelerini yükle
  Future<void> loadClubMembers(String clubId) async {
    isLoading.value = true;
    try {
      clubMembers.value = await clubRepository.getClubMembers(clubId);
    } catch (e) {
      Get.snackbar('Hata', 'Kulüp üyeleri yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Kulübün başvurularını yükle
  Future<void> loadClubApplications(String clubId) async {
    isLoading.value = true;
    try {
      clubApplications.value = await clubRepository.getClubApplications(clubId);
    } catch (e) {
      Get.snackbar('Hata', 'Başvurular yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Başvuruyu onayla
  Future<void> approveApplication(String applicationId, String clubId, String userId) async {
    try {
      await clubRepository.approveApplication(applicationId, clubId, userId);
      Get.snackbar('Başarılı', 'Başvuru onaylandı.');
      loadClubApplications(clubId); // Başvuruları yeniden yükle
      loadClubMembers(clubId); // Üyeleri yeniden yükle
    } catch (e) {
      Get.snackbar('Hata', 'Başvuru onaylanamadı: $e');
    }
  }

  // Başvuruyu reddet
  Future<void> rejectApplication(String applicationId) async {
    try {
      await clubRepository.rejectApplication(applicationId);
      Get.snackbar('Başarılı', 'Başvuru reddedildi.');
    } catch (e) {
      Get.snackbar('Hata', 'Başvuru reddedilemedi: $e');
    }
  }
}
