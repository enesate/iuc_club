import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/auth_controller.dart';
import 'package:iuc_club/presentation/controllers/membership_request_controller.dart';

class MembershipRequestsPage extends StatelessWidget {
  final String clubId;

  MembershipRequestsPage({required this.clubId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MembershipRequestsController(Get.find()));

    // Başvuruları yükle
    controller.loadClubApplications(clubId);
    controller.loadClubMembers(clubId);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Üyelik Yönetimi'),
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
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Üyeler'),
                Tab(text: 'Başvurular'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Üyeler Sekmesi
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.clubMembers.isEmpty) {
                      return const Center(child: Text('Henüz üye yok.'));
                    }

                    return ListView.builder(
                      itemCount: controller.clubMembers.length,
                      itemBuilder: (context, index) {
                        final member = controller.clubMembers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(member.name[0]),
                          ),
                          title: Text(member.name),
                          subtitle: Text(member.email),
                        );
                      },
                    );
                  }),

                  // Başvurular Sekmesi
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.clubApplications.isEmpty) {
                      return const Center(child: Text('Henüz bir başvuru yok.'));
                    }

                    return ListView.builder(
                      itemCount: controller.clubApplications.length,
                      itemBuilder: (context, index) {
                        final request = controller.clubApplications[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(request['name'][0]),
                            ),
                            title: Text(request['name']),
                            subtitle: Text('Durum: ${request['status']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: () {
                                    controller.approveApplication(
                                      request["id"],
                                      clubId,
                                      request["userId"],
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    controller.rejectApplication(request["id"]);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
