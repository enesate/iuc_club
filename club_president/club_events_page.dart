import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/auth_controller.dart';
import 'package:iuc_club/presentation/controllers/club_president_controller.dart';
import 'package:iuc_club/presentation/pages/club_president/create_event_page.dart';
import 'package:iuc_club/presentation/pages/club_president/event_details_page.dart';

class ClubEventsPage extends StatelessWidget {
  final String clubId;

  ClubEventsPage({required this.clubId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClubPresidentController(Get.find(), Get.find(), Get.find()));
    controller.loadEvents(clubId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Etkinlikler'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: () {
              Get.find<AuthController>().logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.events.length,
          itemBuilder: (context, index) {
            final event = controller.events[index];
            return Card(
              child: ListTile(
                title: Text(event.name),
                subtitle: Text(event.description),
                trailing: Text(event.date.toString()),
                onTap: () async {
                  // Etkinlik detayları sayfasına yönlendirme
                  //Get.toNamed('/event_details', arguments: event);
                  await controller.loadParticipants(event.participants);
                  Get.to(() => EventDetailsPage(event: event));
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateEventPage(clubId: clubId));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
