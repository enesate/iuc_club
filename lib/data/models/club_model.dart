import 'package:cloud_firestore/cloud_firestore.dart';

class ClubModel {
  final String id; // Kulübün benzersiz ID'si
  final String name; // Kulüp adı
  final String advisorId; // Danışmanın kullanıcı ID'si
  final String presidentId; // Başkanın kullanıcı ID'si
  final List<String> members; // Kulüp üyelerinin kullanıcı ID'leri
  final DateTime? createdAt; // Kulübün oluşturulma tarihi

  ClubModel({
    required this.id,
    required this.name,
    required this.advisorId,
    required this.presidentId,
    required this.members,
    this.createdAt,
  });

  // Firebase'den gelen veriyi ClubModel'e dönüştür
  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: json['id'] as String,
      name: json['name'] as String,
      advisorId: json['advisorId'] as String,
      presidentId: json['presidentId'] as String,
      members: List<String>.from(json['members'] ?? []),
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
    );
  }

  // ClubModel'i Firebase için bir JSON nesnesine dönüştür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'advisorId': advisorId,
      'presidentId': presidentId,
      'members': members,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
