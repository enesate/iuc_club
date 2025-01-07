// presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Hesabınızı Oluşturun', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
              onChanged: (value) => controller.name.value = value,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) => controller.email.value = value,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
              onChanged: (value) => controller.password.value = value,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Şifre Tekrar'),
              obscureText: true,
              onChanged: (value) => controller.confirmPassword.value = value,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Rol'),
              value: controller.roles.first,
              onChanged: (value) {
                if (value != null) {
                  controller.role = value;
                }
              },
              items: controller.roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.register,
                child: const Text('Kayıt Ol'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Hesabınız var mı?'),
                TextButton(
                  onPressed: () => Get.toNamed('/login'),
                  child: const Text('Giriş Yap'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
