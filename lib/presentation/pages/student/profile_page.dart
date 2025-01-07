import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  ProfilePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController(Get.find(), Get.find()));
    controller.loadProfile(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
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

        final profile = controller.profile;
        final clubs = controller.clubs;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profil Resmi
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profile['profilePicture'] != null ? NetworkImage(profile['profilePicture']) : null,
                  child: profile['profilePicture'] == null ? const Icon(Icons.person, size: 50) : null,
                ),
                const SizedBox(height: 16),
                // Kullanıcı Bilgileri
                Text(profile['name'] ?? 'Ad Soyad', style: const TextStyle(fontSize: 20)),
                Text(profile['email'] ?? 'Email'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Profili düzenleme ekranına yönlendirme
                  },
                  child: const Text('Profili Düzenle'),
                ),
                const Divider(height: 40),
                // Üye Olduğu Kulüpler
                const Text('Üye Olduğum Kulüpler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                clubs.isEmpty
                    ? const Text('Henüz bir kulübe üye değilsiniz.')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: clubs.length,
                        itemBuilder: (context, index) {
                          final club = clubs[index];
                          return ListTile(
                            title: Text(club['name']),
                            subtitle: Text(club['description'] ?? ''),
                          );
                        },
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Kullanıcı çıkış işlemi (Firebase Auth)
                  },
                  child: const Text('Çıkış Yap'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
