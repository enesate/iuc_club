import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/advisor_controller.dart';

class AdvisorClubPresidentPage extends StatelessWidget {
  final String advisorId;

  AdvisorClubPresidentPage({required this.advisorId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdvisorController(Get.find()));

    // Kulüp bilgilerini yükle
    controller.loadClubInfo(advisorId);

    final emailController = TextEditingController();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final club = controller.clubInfo;
      final currentPresident = controller.currentPresidentId.value;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentPresident.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mevcut Başkan: ${controller.userPresident.value["name"] ?? "Atanmamış"}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(currentPresident),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.removePresident(club["id"]);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Başkanı Görevden Al'),
                  ),
                ],
              ),
            if (currentPresident == "" || currentPresident.isEmpty)
              Column(
                children: [
                  const Text(
                    'Kulübün şu anda bir başkanı yok.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Yeni Başkan Atama:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Başkan Email',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (email) {
                      if (email.trim().isEmpty) {
                        Get.snackbar('Hata', 'Lütfen bir email girin.');
                        return;
                      }
                      controller.assignPresident(club["id"], email.trim());
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (emailController.text.trim().isEmpty) {
                        Get.snackbar('Hata', 'Lütfen bir email girin.');
                        return;
                      }
                      controller.assignPresident(club["id"], emailController.text.trim());
                    },
                    child: const Text('Başkan Atama'),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }
}
