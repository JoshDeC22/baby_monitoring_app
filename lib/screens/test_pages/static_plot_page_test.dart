// live_plot_page.dart
import 'dart:math';

import 'package:baby_monitoring_app/utils/data_model.dart';
import 'package:flutter/material.dart';
import '../../widgets/graph.dart';

class StaticPlotPageTest extends StatelessWidget {
  const StaticPlotPageTest({super.key});


  @override
  Widget build(BuildContext context) {
    DateTime dummyTime = DateTime.parse('2025-01-01 11:17:00'); // Year/Month/Day
    final List<ChartData> dummyData = [
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
    ];
    final data = [dummyData, dummyData];
    final names = ["Glucose", "Lactate"];

    return Scaffold( //provides the structure for the screen
      appBar: AppBar( //top navigation bar
        centerTitle: true, 
        title: const Text('Real-Time Blood Parameter Monitoring',
         style: TextStyle(fontWeight: FontWeight.bold, ),),
      ),
      body: SingleChildScrollView( //vertical scrolling
        scrollDirection: Axis.vertical,
        child: Column( //arrange graph widgets down the page
          crossAxisAlignment: CrossAxisAlignment.stretch, // Graphs fill the full width
          children: [
          for (int i = 0; i < data.length; i++)
            if (i == 0) 
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GraphWidget(number: 1, data: data[i], paramName: names[i], lineColor: Colors.red, plotType: 's', commentData: []),
              )
            else if (i == 1)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GraphWidget(number: 2, data: dummyData, paramName: names[i], lineColor: Colors.green, plotType: 's', commentData: []),
              )
            else
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GraphWidget(number: i + 1, data: data[i], paramName: names[i], lineColor: generateRandomColor(), plotType: 's', commentData: []),
              )
              
        ],
      ),
      ),
    );
  }
}


Color generateRandomColor() {
  final random = Random();
  return Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
}