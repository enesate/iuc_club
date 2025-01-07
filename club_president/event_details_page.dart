import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/data/models/event_model.dart';
import 'package:iuc_club/presentation/controllers/club_president_controller.dart';

class EventDetailsPage extends StatefulWidget {
  final EventModel event; // Etkinlik bilgileri

  EventDetailsPage({required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClubPresidentController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Etkinlik Bilgileri
            Text('Tarih: ${widget.event.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.event.description),
            const SizedBox(height: 16),
            Text(
              'Katılımcılar:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Katılımcılar Listesi
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.participants.isEmpty) {
                  return Center(child: Text('Hiç katılımcı yok.'));
                }

                return ListView.builder(
                  itemCount: controller.participants.length,
                  itemBuilder: (context, index) {
                    final participant = controller.participants[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(participant.name[0]), // İlk harf avatar
                      ),
                      title: Text(participant.name),
                      subtitle: Text(participant.email),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
