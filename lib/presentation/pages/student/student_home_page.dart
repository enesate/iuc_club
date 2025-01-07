import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/auth_controller.dart';
import 'package:iuc_club/presentation/widgets/student_nav_bar.dart';
import '../../controllers/student_controller.dart';
import '../../widgets/event_card.dart';

class StudentHomePage extends StatefulWidget {
  final String userId;

  StudentHomePage({required this.userId});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = Get.put(StudentController(Get.find()));
        // İlk sayfa oluşturulurken fetch işlemini başlat
        controller.loadAllEvents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(StudentController(Get.find()));
    //controller.fetchAllEvents(widget.userId, widget.myClubIds);
    final controller = Get.find<StudentController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ana Sayfa'),
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
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  tabs: [
                    Tab(
                      text: 'Tüm Etkinlikler',
                    ),
                    Tab(text: 'Kulüp Etkinliklerim'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tüm etkinlikler tabı
                    ListView.builder(
                      itemCount: controller.allEvents.length,
                      itemBuilder: (context, index) {
                        final event = controller.allEvents[index];
                        return EventCard(
                          event: event,
                          onJoin: () {
                            //controller.joinEvent(userId, event.id, event.clubId);
                          },
                        );
                      },
                    ),
                    // Üye olunan kulüplerin etkinlikleri tabı
                    ListView.builder(
                      itemCount: controller.userClubEvents.length,
                      itemBuilder: (context, index) {
                        final event = controller.userClubEvents[index];
                        return EventCard(
                          event: event,
                          onJoin: () {
                            //controller.joinEvent(userId, event.id, event.clubId);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
