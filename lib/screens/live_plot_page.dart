// live_plot_page.dart
import 'package:flutter/material.dart';
import '../widgets/graph_item.dart';
import '../widgets/data_model.dart';

class LivePlotPage extends StatelessWidget {
  const LivePlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> glucoseData = [
      ChartData(DateTime.now(), 4.5),
      ChartData(DateTime.now().add(const Duration(minutes: 1)), 5.0),
    ];
    final List<ChartData> lactateData = [
      ChartData(DateTime.now(), 1.2),
      ChartData(DateTime.now().add(const Duration(minutes: 1)), 1.4),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Live Data Plot')),
      body: Column(
        children: [
          Expanded(child: GraphItem(number: 1, plotType: 'glucose', data: glucoseData)),
          Expanded(child: GraphItem(number: 2, plotType: 'lactate', data: lactateData)),
        ],
      ),
    );
  }
}