import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iuc_club/presentation/controllers/advisor_controller.dart';

class AdvisorClubEventsPage extends StatelessWidget {
  final String advisorId;

  AdvisorClubEventsPage({required this.advisorId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdvisorController(Get.find()));

    // Kulübün etkinliklerini yükle
    controller.loadClubInfo(advisorId);

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final club = controller.clubInfo;

      if (club.isEmpty) {
        return Center(child: Text('Danışmanlık yaptığınız bir kulüp bulunamadı.'));
      }

      final events = controller.clubEvents;

      if (events.isEmpty) {
        return Center(child: Text('Henüz bir etkinlik bulunmuyor.'));
      }

      return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(event['name']),
              subtitle: Text('Tarih: ${convertTimestampToDate(event['date'])}'),
            ),
          );
        },
      );
    });
  }

  String convertTimestampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Timestamp'i DateTime'a çevir
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime); // Tarihi formatla
    return formattedDate;
  }
}
