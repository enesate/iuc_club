import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String serverKey = 'YOUR_SERVER_KEY'; // Firebase Console'dan alınan Server Key
  static const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  // Bildirim gönderme
  Future<void> sendNotification({
    required List<String> tokens,
    required String title,
    required String body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'registration_ids': tokens,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Bildirim gönderildi: ${response.body}');
      } else {
        print('Bildirim gönderilemedi: ${response.body}');
        throw Exception('Bildirim gönderimi başarısız oldu.');
      }
    } catch (e) {
      throw Exception('Bildirim gönderimi sırasında hata: $e');
    }
  }
}
