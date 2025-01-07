import 'package:get/get.dart';
import 'package:iuc_club/data/models/event_model.dart';
import 'package:iuc_club/data/repositories/event_repository.dart';

class StudentController extends GetxController {
  final EventRepository eventRepository;

  var events = <EventModel>[].obs;
  var allEvents = <EventModel>[].obs;
  var userClubEvents = <EventModel>[].obs;
  var myJoinedEvents = <EventModel>[].obs;
  var isLoading = true.obs;

  StudentController(this.eventRepository);

  // Kullanıcının kulüp etkinliklerini yükle
  Future<void> loadUserClubEvents(List<String> clubIds) async {
    isLoading.value = true;
    try {
      userClubEvents.value = await eventRepository.getEventsForUserClubs(clubIds);
    } catch (e) {
      Get.snackbar('Hata', 'Etkinlikler yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Tüm etkinlikleri yükle
  Future<void> loadAllEvents() async {
    isLoading.value = true;
    try {
      allEvents.value = await eventRepository.getAllEvents();
    } catch (e) {
      Get.snackbar('Hata', 'Tüm etkinlikler yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Kullanıcıyı etkinliğe kat
  Future<void> joinEvent(String eventId, String userId) async {
    try {
      await eventRepository.joinEvent(eventId, userId);
      Get.snackbar('Başarılı', 'Etkinliğe başarıyla katıldınız.');
    } catch (e) {
      Get.snackbar('Hata', 'Etkinliğe katılınamadı: $e');
    }
  }

// Kullanıcının katıldığı etkinlikleri yükle
  Future<void> loadMyJoinedEvents(String userId) async {
    isLoading.value = true;
    try {
      myJoinedEvents.value = await eventRepository.getUserEvents(userId);
    } catch (e) {
      Get.snackbar('Hata', 'Katıldığınız etkinlikler yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /* Future<void> joinEvent(String userId, String eventId, String clubId) async {
    // Check if user is a member of the club
    final isMember = await studentRepository.isUserClubMember(userId, clubId);
    if (!isMember) {
      // Add user to club first
      await studentRepository.addUserToClub(userId, clubId);
    }
    // Join the event
    await studentRepository.addUserToEvent(userId, eventId);
    Get.snackbar('Başarılı', 'Etkinliğe katıldınız!');
  } */
}
