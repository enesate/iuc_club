import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/auth_controller.dart';
import 'advisor_club_events_page.dart';
import 'advisor_club_president_page.dart';
import 'advisor_club_info_page.dart';

class AdvisorMainPage extends StatefulWidget {
  final String advisorId;

  AdvisorMainPage({required this.advisorId});

  @override
  _AdvisorMainPageState createState() => _AdvisorMainPageState();
}

class _AdvisorMainPageState extends State<AdvisorMainPage> {
  int _currentIndex = 0; // Aktif sekme indeksi

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      AdvisorClubEventsPage(advisorId: widget.advisorId),
      AdvisorClubPresidentPage(advisorId: widget.advisorId),
      AdvisorClubInfoPage(advisorId: widget.advisorId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danışman Paneli'),
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
      body: _pages[_currentIndex], // Aktif sayfa
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Etkinlikler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Başkan Yönetimi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Kulüp Bilgileri',
          ),
        ],
      ),
    );
  }
}
