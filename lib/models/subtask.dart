import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Subtask {
  Subtask({String? id, required this.title, String? username, DateTime? date})
      : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        username = username ?? '',
        date = date ?? DateTime.now();

  String id;
  String title;
  String username;
  DateTime date;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'date': date.toIso8601String(),
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    final rawdate = map['date'];
    DateTime? parseddate;
    if (rawdate is Timestamp) {
      parseddate = rawdate.toDate();
    } else if (rawdate is String && rawdate.isNotEmpty) {
      parseddate = DateTime.tryParse(rawdate);
    } else if (rawdate is DateTime) {
      parseddate = rawdate;
    }
    return Subtask(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      username: (map['username'] ?? '').toString(),
      date: parseddate,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Subtask.fromJson(String source) =>
      Subtask.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
