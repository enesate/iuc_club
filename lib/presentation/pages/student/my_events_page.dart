import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/auth_controller.dart';
import '../../controllers/student_controller.dart';
import '../../widgets/event_card.dart';

class MyEventsPage extends StatefulWidget {
  final String userId;

  MyEventsPage({required this.userId});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = Get.find<StudentController>();
        controller.loadMyJoinedEvents(widget.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Etkinliklerim'),
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

        if (controller.myJoinedEvents.isEmpty) {
          return Center(child: Text('Henüz bir etkinliğe katılmadınız.'));
        }

        return ListView.builder(
          itemCount: controller.myJoinedEvents.length,
          itemBuilder: (context, index) {
            final event = controller.myJoinedEvents[index];
            return EventCard(
              event: event,
            );
          },
        );
      }),
    );
  }
}
