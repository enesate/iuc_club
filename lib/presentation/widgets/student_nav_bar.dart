import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/auth_controller.dart';
import 'package:iuc_club/presentation/controllers/profile_controller.dart';
import 'package:iuc_club/presentation/controllers/student_controller.dart';
import 'package:iuc_club/presentation/pages/student/my_events_page.dart';
import 'package:iuc_club/presentation/pages/student/profile_page.dart';
import 'package:iuc_club/presentation/pages/student/student_home_page.dart';

class StudentNavBar extends StatefulWidget {
  final String userId;
  const StudentNavBar({super.key, required this.userId});

  @override
  State<StudentNavBar> createState() => _StudentNavBarState();
}

class _StudentNavBarState extends State<StudentNavBar> {
  int _currentIndex = 0; // Aktif sayfa indeksi

  // Her sekmeye karşılık gelen sayfalar
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final controller = Get.put(StudentController(Get.find()));
    final controller1 = Get.put(ProfileController(Get.find(), Get.find()));
    _pages = [
      StudentHomePage(userId: widget.userId), // Ana Sayfa
      MyEventsPage(userId: widget.userId), // Etkinlikler Sayfası
      ProfilePage(userId: widget.userId), // Profil Sayfası
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Etkinliklerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Aktif indeksi güncelle
          });
        },
      ),
    );
  }
}
