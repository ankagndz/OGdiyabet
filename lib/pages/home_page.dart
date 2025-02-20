import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/measurement_provider.dart';
import 'new_measurement_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Build işlemi tamamlandıktan sonra loadMeasurements'ı çağır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MeasurementProvider>(context, listen: false).loadMeasurements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Günlük Özet', 
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 20),
          _buildGlucoseChart(),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildGlucoseChart() {
    return Consumer<MeasurementProvider>(
      builder: (context, provider, child) {
        final measurements = provider.measurements;
        final spots = measurements.asMap().entries.map((entry) {
          double value = entry.value.glucoseLevel;
          // Negatif değerleri sıfıra çevir
          value = value < 0 ? 0 : value;
          return FlSpot(entry.key.toDouble(), value);
        }).toList();

        // Maksimum değeri hesapla ve yuvarla
        double maxY = spots.isEmpty ? 200 : spots.map((spot) => spot.y).reduce((max, value) => value > max ? value : max);
        maxY = ((maxY / 50).ceil() * 50).toDouble();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kan Şekeri Takibi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2732),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: maxY > 200 ? maxY / 4 : 50,
                    getDrawingHorizontalLine: (value) {
                      Color lineColor = Colors.grey.withOpacity(0.2);
                      if (value == 70) lineColor = Colors.orange.withOpacity(0.5);
                      if (value == 140) lineColor = Colors.red.withOpacity(0.5);
                      return FlLine(color: lineColor, strokeWidth: 1);
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}',
                              style: const TextStyle(color: Colors.white70));
                        },
                        reservedSize: 35,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
                      isCurved: true,
                      color: null, // renk null olmalı gradient için
                      barWidth: 3,
                      gradient: LinearGradient(
                        colors: const [
                          Colors.orange,      // Düşük değerler
                          Colors.greenAccent, // Normal değerler
                          Colors.red,         // Yüksek değerler
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          Color dotColor = Colors.greenAccent;
                          if (spot.y < 70) dotColor = Colors.orange;
                          if (spot.y > 140) dotColor = Colors.red;
                          return FlDotCirclePainter(
                            radius: 6,
                            color: dotColor,
                            strokeWidth: 2,
                            strokeColor: dotColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.greenAccent.withOpacity(0.1),
                            Colors.orange.withOpacity(0.1),
                            Colors.red.withOpacity(0.1),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Normal aralık: 70-140 mg/dL\n'
                'Turuncu çizgi: Düşük kan şekeri uyarısı (70 mg/dL)\n'
                'Kırmızı çizgi: Yüksek kan şekeri uyarısı (140 mg/dL)',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getPressureColor(double value) {
    if (value > 140) return Colors.red;
    if (value < 90) return Colors.orange;
    return Colors.blueAccent;
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildActionButton(
          icon: Icons.add_chart,
          label: 'Yeni Ölçüm',
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewMeasurementPage(),
              ),
            );
            // Ölçümleri yeniden yükle
            Provider.of<MeasurementProvider>(context, listen: false).loadMeasurements();
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF1C2732),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(label, 
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
