import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/measurement_provider.dart';

class MeasurementsPage extends StatelessWidget {
  const MeasurementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MeasurementProvider>(
      builder: (context, provider, child) {
        final measurements = provider.measurements;
        
        if (measurements.isEmpty) {
          return const Center(
            child: Text('Henüz ölçüm bulunmuyor', 
              style: TextStyle(color: Colors.white70)),
          );
        }

        return ListView.builder(
          itemCount: measurements.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final measurement = measurements[index];
            return Card(
              color: const Color(0xFF1C2732),
              child: ListTile(
                title: Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(measurement.dateTime),
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kan Şekeri: ${measurement.glucoseLevel} mg/dL',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Kilo: ${measurement.weight} kg',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (measurement.note.isNotEmpty)
                      Text(
                        'Not: ${measurement.note}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteMeasurement(measurement.id!);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
