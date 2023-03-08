import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';
import 'package:wup/app/widgets/bottom_navigation_bar.dart';

class BioRhythmScreen extends StatefulWidget {
  const BioRhythmScreen({Key? key}) : super(key: key);

  @override
  _BioRhythmScreenState createState() => _BioRhythmScreenState();
}

class _BioRhythmScreenState extends State<BioRhythmScreen> {
  late final List<BioData> data;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    final birthday = DateTime.parse(GetStorage().read('birthday'));
    final today = DateTime.now();
    final delta = today.difference(birthday).inDays;

    data = List.generate(
      31,
      (index) {
        final date = today.add(Duration(days: index - 15));
        final countDays = delta + index - 15;
        final bioPhy = sin(2 * pi * countDays / 23) * 100;
        final bioEmo = sin(2 * pi * countDays / 28) * 100;
        final bioInt = sin(2 * pi * countDays / 33) * 100;
        return BioData(date, bioPhy, bioEmo, bioInt);
      },
    );

    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Your Bio Rhythm',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: charts.TimeSeriesChart(
                [
                  charts.Series<BioData, DateTime>(
                    id: 'Physical',
                    colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                    domainFn: (data, _) => data.date,
                    measureFn: (data, _) => data.bioPhy,
                    data: data,
                  ),
                  charts.Series<BioData, DateTime>(
                    id: 'Emotional',
                    colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (data, _) => data.date,
                    measureFn: (data, _) => data.bioEmo,
                    data: data,
                  ),
                  charts.Series<BioData, DateTime>(
                    id: 'Intellectual',
                    colorFn: (_, __) =>
                        charts.MaterialPalette.green.shadeDefault,
                    domainFn: (data, _) => data.date,
                    measureFn: (data, _) => data.bioInt,
                    data: data,
                  ),
                ],
                animate: true,
                behaviors: [
                  charts.SeriesLegend(
                    position: charts.BehaviorPosition.top,
                    desiredMaxRows: 1,
                    showMeasures: true,
                  ),
                ],
                defaultRenderer: charts.LineRendererConfig(includePoints: true),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 4),
    );
  }
}

class BioData {
  final DateTime date;
  final double bioPhy;
  final double bioEmo;
  final double bioInt;

  BioData(this.date, this.bioPhy, this.bioEmo, this.bioInt);
}
