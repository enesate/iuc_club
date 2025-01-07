import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/advisor_controller.dart';

class AdvisorClubInfoPage extends StatelessWidget {
  final String advisorId;

  AdvisorClubInfoPage({required this.advisorId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdvisorController(Get.find()));

    // Kulüp bilgilerini yükle
    controller.loadClubInfo(advisorId);

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final club = controller.clubInfo;

      if (club.isEmpty) {
        return Center(child: Text('Danışmanlık yaptığınız bir kulüp bulunamadı.'));
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kulüp Adı: ${club['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Başkan: ${club['presidentEmail'] ?? 'Atanmamış'}'),
            SizedBox(height: 8),
            Text('Üye Sayısı: ${club['memberCount'] ?? 0}'),
          ],
        ),
      );
    });
  }
}
