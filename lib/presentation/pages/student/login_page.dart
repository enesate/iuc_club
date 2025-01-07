// presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuc_club/presentation/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('İÜC Club Hoş Geldiniz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Hesabınıza Giriş Yapın', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
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
            const SizedBox(height: 0),
            // şifremi unuttum
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Şifrenizi Unuttunuz mu?', style: TextStyle(fontSize: 12)),
                TextButton(
                  onPressed: () => Get.toNamed('/forgot-password'),
                  child: const Text('Şifremi Sıfırla', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.login,
                child: const Text('Giriş Yap'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Hesabınız yok mu?'),
                TextButton(
                  onPressed: () => Get.toNamed('/register'),
                  child: const Text('Kayıt Ol'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
  // Öğrenci Giriş Formu
  


