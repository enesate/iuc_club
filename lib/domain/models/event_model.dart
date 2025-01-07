import 'dart:ffi';

class EventModel {
  int id;
  final String name;
  final String date;
  final String description;
  final String clubId;
  final List<String>? participants;

  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.description,
    required this.clubId,
    required this.participants,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      description: map['description'] ?? '',
      clubId: map['clubId'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
    );
  }
  //fromJson

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      clubId: json['clubId'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
    );
  }
  /* factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      description: map['description'] ?? '',
    );
  } */
}
