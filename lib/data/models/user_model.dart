import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role; // student, president, advisor
  final List<String> clubIds; // Kullanıcının üye olduğu kulüplerin ID'leri
  final String? fcmToken; // Bildirimler için Firebase cihaz tokenı
  final DateTime? createdAt; // Kullanıcının oluşturulma tarihi

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.clubIds,
    this.fcmToken,
    this.createdAt,
  });

  // Firebase'den gelen veriyi UserModel'e dönüştür
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '', // Varsayılan olarak boş bir string atanır
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      clubIds: List<String>.from(json['clubIds'] ?? []),
      fcmToken: json['fcmToken'] as String?,
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
    );
  }

  // UserModel'i Firebase için bir JSON nesnesine dönüştür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'clubIds': clubIds,
      'fcmToken': fcmToken,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
