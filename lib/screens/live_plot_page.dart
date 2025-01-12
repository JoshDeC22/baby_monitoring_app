// live_plot_page.dart
import 'package:flutter/material.dart';
import '../widgets/data_model.dart';
import '../widgets/graph.dart';

class LivePlotPage extends StatelessWidget {
  const LivePlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime dummyTime = DateTime.parse('2025-01-01 11:00:00Z');
    final List<ChartData> glucoseData = [
      ChartData(dummyTime, 4),
      ChartData(dummyTime.add(const Duration(minutes: 1)), 5),
      ChartData(dummyTime.add(const Duration(minutes: 2)), 4),
      ChartData(dummyTime.add(const Duration(minutes: 3)), 5),
      ChartData(dummyTime.add(const Duration(minutes: 4)), 2),
      ChartData(dummyTime.add(const Duration(minutes: 5)), 1),
      ChartData(dummyTime.add(const Duration(minutes: 6)), 3),
      ChartData(dummyTime.add(const Duration(minutes: 7)), 2),
      ChartData(dummyTime.add(const Duration(minutes: 8)), 4),
      ChartData(dummyTime.add(const Duration(minutes: 9)), 6),
      ChartData(dummyTime.add(const Duration(hours: 1)), 3),
    ];
    final List<ChartData> lactateData = [
      ChartData(DateTime.now(), 1),
      ChartData(DateTime.now().add(const Duration(minutes: 1)), 1),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Live Data Plot')),
      body: Column(
        children: [
          Expanded(
              child: GraphWidget(
            number: 1,
            paramName: 'glucose',
            data: glucoseData,
            lineColor: Colors.green,
            plotType: 's',
          )),
          Expanded(
              child: GraphWidget(
            number: 2,
            paramName: 'lactate',
            data: lactateData,
            lineColor: Colors.red,
            plotType: 's',
          )),
        ],
      ),
    );
  }
}
