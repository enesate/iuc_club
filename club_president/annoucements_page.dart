import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/annoucement_controller.dart';
import 'package:iuc_club/presentation/controllers/auth_controller.dart';
import 'package:iuc_club/presentation/controllers/club_president_controller.dart';
import 'package:iuc_club/presentation/pages/club_president/create_annoucements_page.dart';

class AnnouncementsPage extends StatelessWidget {
  final String clubId;

  AnnouncementsPage({required this.clubId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnnouncementController(Get.find(), Get.find(), Get.find()));
    final eventController = Get.find<ClubPresidentController>();

    controller.loadAnnouncements(clubId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Duyurular'),
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

        if (controller.announcements.isEmpty) {
          return Center(child: Text('Henüz bir duyuru yok.'));
        }

        return ListView.builder(
          itemCount: controller.announcements.length,
          itemBuilder: (context, index) {
            final announcement = controller.announcements[index];
            return Card(
              child: ListTile(
                title: Text(announcement['title']),
                subtitle: Text(announcement['message']),
                //trailing: Text(announcement['createdAt'].toString()),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'createAnnouncement',
        onPressed: () {
          // _showCreateAnnouncementDialog(context, clubId, eventController, controller);
          Get.to(() => CreateAnnouncementPage(clubId: clubId));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
