import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getx/models/subtask.dart';

class Task {
  Task({
    this.id = '',
    required this.title,
    this.durationMinutes = 0,
    this.createdAt,
    List<Subtask>? subtasks,
  }) : subtasks = subtasks ?? <Subtask>[];

  String id;
  String title;
  int durationMinutes;
  DateTime? createdAt;
  final List<Subtask> subtasks;

  DateTime? get effectiveDeadline {
    if (createdAt != null && durationMinutes > 0) {
      return createdAt!.add(Duration(minutes: durationMinutes));
    }
    return null;
  }

  bool get isFailed {
    final d = effectiveDeadline;
    return d != null && DateTime.now().isAfter(d);
  }

  Duration? get timeRemaining {
    final d = effectiveDeadline;
    if (d == null) return null;
    final diff = d.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'subtasks': subtasks.map((s) => s.toMap()).toList(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    final rawsubtasks = (map['subtasks'] as List<dynamic>?) ?? const [];

    DateTime? createdAt;
    final rawCreatedAt = map['createdAt'];
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    }

    return Task(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      durationMinutes: (map['durationMinutes'] as num?)?.toInt() ?? 0,
      createdAt: createdAt,
      subtasks: rawsubtasks
          .whereType<Map>()
          .map((m) => Subtask.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
