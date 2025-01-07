// main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/core/app_theme.dart';
import 'package:iuc_club/data/datasources/notification_service.dart';
import 'package:iuc_club/data/repositories/advisor_repository.dart';
import 'package:iuc_club/data/repositories/annoucement_repository.dart';
import 'package:iuc_club/data/repositories/auth_repository.dart';
import 'package:iuc_club/data/repositories/club_repository.dart';
import 'package:iuc_club/data/repositories/event_repository.dart';
import 'package:iuc_club/data/repositories/student_repository.dart';
import 'package:iuc_club/data/repositories/user_repositor.dart';
import 'package:iuc_club/domain/usecases/fetch_user_clubs.dart';
import 'package:iuc_club/domain/usecases/fetch_user_profile.dart';
import 'package:iuc_club/firebase_options.dart';
import 'package:iuc_club/presentation/pages/student/login_page.dart';
import 'package:iuc_club/presentation/pages/student/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(StudentRepository());
  Get.put(UserRepository());
  Get.put(ClubRepository());
  Get.put(EventRepository());
  Get.put(AuthRepository());
  Get.put(AdvisorRepository());
  Get.put(NotificationService());
  Get.put(AnnouncementRepository());
  Get.put(FetchUserProfile(Get.find()));
  Get.put(FetchUserClubs(Get.find()));
  initializeApp();
  runApp(MyApp());
}

void initializeApp() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print('User is logged in: ${user.email}');
    // Oturum açmış kullanıcı için token dinleyicisini başlat
    final authRepository = AuthRepository();
    authRepository.setupFcmTokenListener(user.uid);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'İÜC Club',
      home: LoginPage(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
      ],
    );
  }
}
