// domain/usecases/auth_usecase.dart
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iuc_club/data/repositories/auth_repository.dart';
import 'package:iuc_club/presentation/pages/advisor/advisor_nav_bar.dart';
import 'package:iuc_club/presentation/pages/club_president/club_president_navbar.dart';
import 'package:iuc_club/presentation/widgets/student_nav_bar.dart';

class AuthUseCase {
  final AuthRepository authRepository;
  AuthUseCase(this.authRepository);

  bool registerUser(String email, String password, String name, String role) {
    // auth repository register user
    authRepository.registerUser(
      email: email,
      password: password,
      name: name,
      role: role,
    );
    print('User registered: $email');

    return true;
  }

  //logout
  Future<void> logout() async {
    await authRepository.logoutUser();
    Get.offAllNamed('/login');
  }

  Future<bool> loginUser(String email, String password) async {
    var user = await authRepository.loginUser(email: email, password: password);

    var club = await authRepository.getClubsByPresident(user.id);

    print('User logged in: $email');

    //go to student home page no return
    if (user.role == 'Öğrenci') {
      Get.off(
        () => StudentNavBar(
          userId: user.id,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (user.role == 'Kulüp Başkanı' && club != null) {
      Get.off(
        () => ClubPresidentNavBar(
          clubId: club.id,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (user.role == 'Danışman') {
      Get.off(
        () => AdvisorMainPage(
          advisorId: user.id,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    return true;
  }

  bool loginClubPresident(String email, String password) {
    print('User logged in: $email');

    //go to student home page no return

    Get.off(
      () => ClubPresidentNavBar(
        clubId: "1",
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    return true;
  }

  bool loginAdvisor(String email, String password) {
    print('User logged in: $email');

    //go to student home page no return

    Get.off(
      () => AdvisorMainPage(
        advisorId: "1",
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    return true;
  }
}
