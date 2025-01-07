// presentation/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:iuc_club/domain/usecases/auth_usecase.dart';

class AuthController extends GetxController {
  final AuthUseCase _authUseCase = AuthUseCase(Get.find());

  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  String role = '';
  var roles = ['Öğrenci', 'Kulüp Başkanı', 'Danışman'];

  void register() async {
    if (password.value != confirmPassword.value) {
      print('Passwords do not match!');
      return;
    }
    if (email.value.isEmpty || password.value.isEmpty || name.value.isEmpty) {
      print('Please fill in all fields!');
      return;
    }
    await _authUseCase.registerUser(
      email.value,
      password.value,
      name.value,
      role,
    );
    Get.snackbar(
      'Kayıt Başarılı',
      'Kullanıcı başarıyla kaydedildi.',
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.back();
  }

  //logout
  Future<void> logout() async {
    await _authUseCase.logout();
  }

  void login() {
    _authUseCase.loginUser(email.value, password.value);
  }
}
