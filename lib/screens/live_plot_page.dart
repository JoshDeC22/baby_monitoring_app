// live_plot_page.dart
import 'package:flutter/material.dart';
import '../widgets/data_model.dart';
import '../widgets/graph.dart';

class LivePlotPage extends StatelessWidget {
  const LivePlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> glucoseData = [
      ChartData(DateTime.now(), 4),
      ChartData(DateTime.now().add(const Duration(minutes: 1)), 5),
    ];
    final List<ChartData> lactateData = [
      ChartData(DateTime.now(), 1),
      ChartData(DateTime.now().add(const Duration(minutes: 1)), 1),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Live Data Plot')),
      body: Column(
        children: [
          Expanded(child: GraphWidget(number: 1, paramName: 'glucose', data: glucoseData, lineColor: Colors.green)),
          Expanded(child: GraphWidget(number: 2, paramName: 'lactate', data: lactateData, lineColor: Colors.red)),
        ],
      ),
    );
  }
}