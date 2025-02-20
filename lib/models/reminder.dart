import 'package:flutter/material.dart';  // TimeOfDay için import ekle

class Reminder {
  final int? id;
  final String title;
  final String description;
  final TimeOfDay time;
  final bool isRepeating;
  final List<bool> weekDays; // [p,s,ç,p,c,c,p]
  final bool isEnabled;
  final String type; // ilaç, insülin, ölçüm, diğer

  Reminder({
    this.id,
    required this.title,
    this.description = '',
    required this.time,
    this.isRepeating = false,
    required this.weekDays,
    this.isEnabled = true,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': '${time.hour}:${time.minute}',
      'isRepeating': isRepeating ? 1 : 0,
      'weekDays': weekDays.map((e) => e ? 1 : 0).join(','),
      'isEnabled': isEnabled ? 1 : 0,
      'type': type,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    final timeParts = map['time'].split(':');
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      time: TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])),
      isRepeating: map['isRepeating'] == 1,
      weekDays: map['weekDays'].split(',').map((e) => e == '1').toList(),
      isEnabled: map['isEnabled'] == 1,
      type: map['type'],
    );
  }
}