
// live_plot_page.dart
import 'package:flutter/material.dart';
import '../widgets/graph_item.dart';

class LivePlotPage extends StatelessWidget {
  const LivePlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Data Plot')),
      body: Column(
        children: [
          Expanded(child: GraphItem(number: 1, plotType: 'glucose')),
          Expanded(child: GraphItem(number: 2, plotType: 'lactate')),
        ],
      ),
    );
  }
}