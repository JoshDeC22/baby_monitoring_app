import 'package:flutter/material.dart';
import '../../widgets/graph.dart';
import 'package:baby_monitoring_app/utils/data_model.dart';
import 'package:baby_monitoring_app/utils/comment_data.dart'; // Import CommentData

class StaticPlotPageTest extends StatelessWidget {
  const StaticPlotPageTest({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime dummyTime = DateTime.parse('2025-01-01 11:00:00'); 

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
      ChartData(dummyTime.add(const Duration(hours: 1)), 3),
    ];

    final data = [dummyData, dummyData]; 
    final names = ["Glucose", "Lactate"];
    final List<CommentData> comments = []; // Initialize comments

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Static Blood Parameter Plot (Dummy Data)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < data.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GraphWidget(
                    number: i + 1,
                    data: data[i],
                    paramName: names[i],
                    lineColor: i == 0 ? Colors.red : Colors.green,
                    plotType: 's',
                    commentData: comments, // Pass comments
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}