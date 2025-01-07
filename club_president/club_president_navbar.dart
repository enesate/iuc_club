import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/club_president_controller.dart';
import 'package:iuc_club/presentation/pages/club_president/annoucements_page.dart';
import 'package:iuc_club/presentation/pages/club_president/club_events_page.dart';
import 'package:iuc_club/presentation/pages/club_president/membership_request_page.dart';

class ClubPresidentNavBar extends StatefulWidget {
  final String clubId;

  ClubPresidentNavBar({required this.clubId});

  @override
  State<ClubPresidentNavBar> createState() => _ClubPresidentNavBarState();
}

class _ClubPresidentNavBarState extends State<ClubPresidentNavBar> {
  int _currentIndex = 0; // Aktif sayfa indeksi

  // Her sekmeye karşılık gelen sayfalar
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    Get.put(ClubPresidentController(Get.find(), Get.find(), Get.find()));
    _pages = [
      // Etkinlikler Sayfası
      ClubEventsPage(clubId: widget.clubId),
      // Duyurular Sayfası
      AnnouncementsPage(clubId: widget.clubId),
      //ClubAnnouncementsPage(clubId: widget.clubId),
      // Başvurular Sayfası
      MembershipRequestsPage(clubId: widget.clubId),
      //ClubApplicationsPage(clubId: widget.clubId),
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
            label: 'Etkinlikler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Duyurular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Başvurular',
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
