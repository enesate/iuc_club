import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String clubId;
  final String name;
  final String description;
  final DateTime date;
  final List<String> participants;
  final DateTime? createdAt;

  EventModel({
    required this.id,
    required this.clubId,
    required this.name,
    required this.description,
    required this.date,
    required this.participants,
    this.createdAt,
  });

  // Firebase'den gelen veriyi EventModel'e dönüştür
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      date: (json['date'] as Timestamp).toDate(),
      participants: List<String>.from(json['participants'] ?? []),
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
    );
  }

  // EventModel'i Firebase için JSON'a dönüştür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clubId': clubId,
      'name': name,
      'description': description,
      'date': Timestamp.fromDate(date),
      'participants': participants,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  //copywith method
  EventModel copyWith({
    String? id,
    String? clubId,
    String? name,
    String? description,
    DateTime? date,
    List<String>? participants,
    DateTime? createdAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
