import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  final List<FlSpot> data;

  const ChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(lineBarsData: [LineChartBarData(spots: data)]),
    );
  }
}
