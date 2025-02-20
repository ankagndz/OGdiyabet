import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/measurement.dart';
import '../providers/measurement_provider.dart';

class NewMeasurementPage extends StatefulWidget {
  const NewMeasurementPage({super.key});

  @override
  State<NewMeasurementPage> createState() => _NewMeasurementPageState();
}

class _NewMeasurementPageState extends State<NewMeasurementPage> {
  final _formKey = GlobalKey<FormState>();
  final _glucoseController = TextEditingController();
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Ölçüm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _glucoseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kan Şekeri (mg/dL)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kan şekeri değerini girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kilo (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kilonuzu girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Not',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMeasurement,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Kaydet'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveMeasurement() {
    if (_formKey.currentState!.validate()) {
      final measurement = Measurement(
        dateTime: DateTime.now(),
        glucoseLevel: double.parse(_glucoseController.text),
        weight: double.parse(_weightController.text),
        note: _noteController.text,
      );

      Provider.of<MeasurementProvider>(context, listen: false)
          .addMeasurement(measurement);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _glucoseController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
