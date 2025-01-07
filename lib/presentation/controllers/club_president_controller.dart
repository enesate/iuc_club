import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/data/models/event_model.dart';
import 'package:iuc_club/data/models/user_model.dart';
import 'package:iuc_club/data/repositories/annoucement_repository.dart';
import '../../data/repositories/club_repository.dart';
import '../../data/repositories/event_repository.dart';

class ClubPresidentController extends GetxController {
  final ClubRepository clubRepository;
  final EventRepository eventRepository;
  final AnnouncementRepository announcementRepository;

  var clubDetails = {}.obs;
  var events = <EventModel>[].obs;
  var membershipRequests = [].obs;
  var isLoading = true.obs;
  var participants = <UserModel>[].obs;

  ClubPresidentController(this.clubRepository, this.eventRepository, this.announcementRepository);

  // Kulüp bilgilerini yükleme
  Future<void> loadClubDetails(String clubId) async {
    isLoading.value = true;
    try {
      //mock data
      clubDetails.value = {
        'id': '1',
        'name': 'Kodlama Kulübü',
        'description': 'Kodlama Kulübü, yazılım geliştirme üzerine çalışmalar yapmaktadır.',
        'imageUrl': 'https://iucclub.com/wp-content/uploads/2021/06/club-1.jpg',
        'president': 'Ahmet Yılmaz',
        'members': ['Ahmet Yılmaz', 'Mehmet Demir'],
      };
      //clubDetails.value = await clubRepository.getClubDetails(clubId);
    } finally {
      isLoading.value = false;
    }
  }

  // Etkinlikleri yükleme
  Future<void> loadEvents(String clubId) async {
    isLoading.value = true;
    try {
      events.value = await eventRepository.getEventsByClubId(clubId);
    } finally {
      isLoading.value = false;
    }
  }

  // Üyelik başvurularını yükleme
  Future<void> loadMembershipRequests(String clubId) async {
    isLoading.value = true;
    try {
      //mock data
      membershipRequests.value = [
        {
          'userId': '1',
          'name': 'Mehmet Demir',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '2',
          'name': 'Ayşe Yılmaz',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '1',
          'name': 'Mehmet Demir',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '2',
          'name': 'Ayşe Yılmaz',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '1',
          'name': 'Mehmet Demir',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '2',
          'name': 'Ayşe Yılmaz',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '1',
          'name': 'Mehmet Demir',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '2',
          'name': 'Ayşe Yılmaz',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '1',
          'name': 'Mehmet Demir',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '2',
          'name': 'Ayşe Yılmaz',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '1',
          'name': 'Mehmet Demir',
          'email': '[email protected]',
          'phone': '5555555555',
        },
        {
          'userId': '2',
          'name': 'Ayşe Yılmaz',
          'email': '[email protected]',
          'phone': '5555555555',
        },
      ];
      //membershipRequests.value = await clubRepository.getMembershipRequests(clubId);
    } finally {
      isLoading.value = false;
    }
  }

  // Yeni etkinlik oluşturma
  Future<void> createEvent(EventModel eventData) async {
    try {
      await eventRepository.createEvent(eventData);
      Get.snackbar(
        "Başarılı",
        "Etkinlik oluşturuldu.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
      );
      loadEvents(eventData.clubId);
    } catch (e) {
      print(e);
      Get.snackbar("Hata", "Etkinlik oluşturulamadı. $e");
    } finally {
      print("Etkinlik oluşturuldu2.");

      //isLoading.value = false;
    }
  }

  // Üyelik başvurularını kabul veya reddetme
  Future<void> manageMembershipRequest(String userId, bool approve) async {
    try {
      //mock data
      membershipRequests.removeWhere((element) => element['userId'] == userId);
      //await clubRepository.manageMembershipRequest(clubDetails['id'], userId, approve);
      Get.snackbar("Başarılı", approve ? "Üyelik onaylandı." : "Üyelik reddedildi.");
      loadMembershipRequests(clubDetails['id']);
    } catch (e) {
      Get.snackbar("Hata", "Üyelik başvurusu yönetilemedi.");
    }
  }

  // Duyuru gönderme
  Future<void> sendAnnouncement(Map<String, dynamic> announcementData) async {
    try {
      //mock data

      //await announcementRepository.sendAnnouncement(announcementData);
      Get.snackbar("Başarılı", "Duyuru gönderildi.");
    } catch (e) {
      Get.snackbar("Hata", "Duyuru gönderilemedi.");
    }
  }

  Future<void> loadParticipants(List<String> userIds) async {
    isLoading.value = true;
    if (userIds.isEmpty) {
      participants.value = [];
      isLoading.value = false;
      return;
    }
    try {
      participants.value = await eventRepository.getEventParticipants(userIds);
    } catch (e) {
      print(e);
      Get.snackbar('Hata', 'Katılımcılar yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
