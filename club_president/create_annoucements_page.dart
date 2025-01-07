import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/annoucement_controller.dart';
import 'package:iuc_club/presentation/controllers/club_president_controller.dart';

class CreateAnnouncementPage extends StatefulWidget {
  final String clubId;

  CreateAnnouncementPage({required this.clubId});

  @override
  State<CreateAnnouncementPage> createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  String? selectedEventName;
  @override
  Widget build(BuildContext context) {
    final announcementController = Get.put(AnnouncementController(Get.find(), Get.find(), Get.find()));
    final eventController = Get.find<ClubPresidentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duyuru Gönder'),
      ),
      body: Obx(() {
        if (announcementController.isLoading.value) {
          return const Center(child: const CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Duyuru Başlığı
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Duyuru Başlığı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Duyuru Mesajı
                TextField(
                  controller: messageController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Duyuru Mesajı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Etkinlik Seçimi
                Obx(() {
                  if (eventController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return DropdownButton<String>(
                    hint: const Text('Etkinlik Seç (Opsiyonel)'),
                    value: selectedEventName,
                    items: eventController.events.map((event) {
                      return DropdownMenuItem(
                        value: event.name,
                        child: Text(event.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedEventName = value;
                      });
                    },
                  );
                }),
                const SizedBox(height: 20),
                // Gönder Butonu
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty || messageController.text.isEmpty) {
                        Get.snackbar('Hata', 'Lütfen tüm alanları doldurun.');
                        return;
                      }

                      announcementController.createAnnouncement(
                        clubId: widget.clubId,
                        title: titleController.text,
                        message: messageController.text,
                      );
                    },
                    child: const Text('Gönder'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
