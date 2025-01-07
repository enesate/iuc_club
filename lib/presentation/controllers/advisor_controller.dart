import 'package:get/get.dart';
import 'package:iuc_club/data/models/user_model.dart';
import '../../data/repositories/advisor_repository.dart';

class AdvisorController extends GetxController {
  final AdvisorRepository advisorRepository;

  var clubInfo = {}.obs; // Kulüp bilgileri
  var clubEvents = <Map<String, dynamic>>[].obs; // Kulüp etkinlikleri
  var isLoading = true.obs;
  var currentPresidentId = ''.obs;
  //user president
  var userPresident = {}.obs;
  AdvisorController(this.advisorRepository);

  // Kulüp bilgilerini yükle
  Future<void> loadClubInfo(String advisorId) async {
    isLoading.value = true;
    try {
      clubInfo.value = await advisorRepository.getAdvisorClub(advisorId);
      if (clubInfo['presidentId'] == null) {
        currentPresidentId.value = ''; // Eğer başkan yoksa, boş bir değer ata
      } else {
        var user = await advisorRepository.getUser(advisorId);
        userPresident.value = user.toJson(); //user president
        currentPresidentId.value = user.id; // Eğer başkan varsa, başkanın ID'sini ata
      }

      await loadClubEvents(clubInfo['id']); // Etkinlikleri de yükle
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Kulüp etkinliklerini yükle
  Future<void> loadClubEvents(String clubId) async {
    try {
      clubEvents.value = await advisorRepository.getClubEvents(clubId);
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    }
  }

  // Başkan atama
  Future<void> assignPresident(String clubId, String email) async {
    try {
      await advisorRepository.assignPresident(clubId, email);
      Get.snackbar('Başarılı', 'Başkan başarıyla atandı.');
      await loadClubInfo(clubInfo['advisorId']); // Kulüp bilgilerini yeniden yükle
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    }
  }

  // Başkan görevden alma
  Future<void> removePresident(String clubId) async {
    try {
      await advisorRepository.removePresident(clubId);
      currentPresidentId.value = '';
      Get.snackbar('Başarılı', 'Başkan başarıyla görevden alındı.');
      await loadClubInfo(clubInfo['advisorId']); // Kulüp bilgilerini yeniden yükle
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    }
  }
}
