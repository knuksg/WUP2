import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BiorhythmGraph extends StatelessWidget {
  final List<double> physical;
  final List<double> emotional;
  final List<double> intellectual;

  const BiorhythmGraph({
    Key? key,
    required this.physical,
    required this.emotional,
    required this.intellectual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Biorhythm',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: -1,
                maxY: 1,
                // Define X and Y axis labels
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                    showTitles: true,
                    margin: 8,
                    getTitles: (value) {
                      // You can customize the X axis labels here
                      // For example, return the date for each day in the range
                      return 'Day ${value.toInt() + 1}';
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    margin: 8,
                    getTitles: (value) {
                      // You can customize the Y axis labels here
                      // For example, return the biorhythm percentage for each label
                      if (value == -1) {
                        return '-100%';
                      } else if (value == 0) {
                        return '0%';
                      } else if (value == 1) {
                        return '100%';
                      } else {
                        return '';
                      }
                    },
                  ),
                ),
                // Define the lines to display on the graph
                lineBarsData: [
                  // Physical line
                  LineChartBarData(
                    spots: _createLineChartSpots(physical),
                    isCurved: true,
                    colors: [Colors.red],
                    barWidth: 2,
                    dotData: FlDotData(
                      show: false,
                    ),
                  ),
                  // Emotional line
                  LineChartBarData(
                    spots: _createLineChartSpots(emotional),
                    isCurved: true,
                    colors: [Colors.green],
                    barWidth: 2,
                    dotData: FlDotData(
                      show: false,
                    ),
                  ),
                  // Intellectual line
                  LineChartBarData(
                    spots: _createLineChartSpots(intellectual),
                    isCurved: true,
                    colors: [Colors.blue],
                    barWidth: 2,
                    dotData: FlDotData(
                      show: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _createLineChartSpots(List<double> values) {
    // Create a list of FlSpot objects to represent the data points
    return List.generate(
      values.length,
      (index) => FlSpot(
        index.toDouble(),
        values[index],
      ),
    );
  }
}
