class Measurement {
  final int? id;
  final DateTime dateTime;
  final double glucoseLevel;
  final String note;
  final double weight;

  Measurement({
    this.id,
    required this.dateTime,
    required this.glucoseLevel,
    this.note = '',
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'glucoseLevel': glucoseLevel,
      'note': note,
      'weight': weight,
    };
  }

  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      glucoseLevel: map['glucoseLevel'],
      note: map['note'],
      weight: map['weight'],
    );
  }
}