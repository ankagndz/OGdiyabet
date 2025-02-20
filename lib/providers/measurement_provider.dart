import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/measurement.dart';

class MeasurementProvider with ChangeNotifier {
  final List<Measurement> _measurements = [];
  List<Measurement> get measurements => _measurements;

  void addMeasurement(Measurement measurement) async {
    final newMeasurement = Measurement(
      id: DateTime.now().millisecondsSinceEpoch,
      dateTime: measurement.dateTime,
      glucoseLevel: measurement.glucoseLevel,
      weight: measurement.weight,
      note: measurement.note,
    );

    _measurements.add(newMeasurement);
    await _saveMeasurementsToPrefs();
    notifyListeners();
  }

  Future<void> loadMeasurements() async {
    final prefs = await SharedPreferences.getInstance();
    final String? measurementsString = prefs.getString('measurements');
    if (measurementsString != null) {
      final List<dynamic> measurementsJson = json.decode(measurementsString);
      _measurements.clear();
      _measurements.addAll(measurementsJson.map((json) => Measurement.fromMap(json)).toList());
    }
    notifyListeners();
  }

  void deleteMeasurement(int id) async {
    _measurements.removeWhere((m) => m.id == id);
    await _saveMeasurementsToPrefs();
    notifyListeners();
  }

  Future<void> _saveMeasurementsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String measurementsString = json.encode(_measurements.map((m) => m.toMap()).toList());
    await prefs.setString('measurements', measurementsString);
  }
}
