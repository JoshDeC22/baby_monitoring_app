import 'package:flutter/material.dart';
import '../../widgets/graph.dart';
import 'package:baby_monitoring_app/utils/data_wrappers/chart_data.dart';
import 'package:baby_monitoring_app/utils/data_wrappers/comment_data.dart'; // Import CommentData
import 'package:baby_monitoring_app/utils/colors.dart';
import 'package:baby_monitoring_app/screens/plot_pages/static_plot_page.dart';

class StaticPlotPageTest extends StatelessWidget {
  const StaticPlotPageTest({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data for Testing
    DateTime dummyTime =
        DateTime.parse('2025-01-01 11:17:00'); // Year/Month/Day
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

    // Dummy Variables for Testing
    final data = [dummyData, dummyData]; 
    final names = ["Glucose", "Lactate"];
    final List<CommentData> comments = []; // Initialize comments

    // Formatting //
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            title: const Text(
              'Static Blood Parameter Monitoring',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.darkBlue,
            centerTitle: true,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // TODO: navigate back to home
                },
                style: TextButton.styleFrom( // Formatting
                  backgroundColor: AppColors.palePink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: AppColors.darkPink, width: 1.5),
                  ),
                ),
                child: const Text('Go Home',
                    style: TextStyle(color: Colors.black, fontSize: 15.0)),
              ),
              IconButton(
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Colors.white, size: 50),
                  onPressed: () => {
                        // TODO: navigate back to home
                      }),
            ],
          ),
        ),
      ),

      // The Main Body. Displays the Graphs
      body: Column(
        children: [
          for (int i = 0; i < data.length; i++)
            if (i == 0)
              Expanded(
                child: GraphWidget(
                    number: 1,
                    data: data[i],
                    paramName: names[i],
                    lineColor: Colors.red,
                    plotType: 's',
                    commentData: []),
              )
            else if (i == 1)
              Expanded(
                child: GraphWidget(
                    number: 2,
                    data: data[i],
                    paramName: names[i],
                    lineColor: Colors.green,
                    plotType: 's',
                    commentData: []),
              )
            else
              Expanded(
                child: GraphWidget(
                    number: i + 1,
                    data: data[i],
                    paramName: names[i],
                    lineColor: generateRandomColor(),
                    plotType: 's',
                    commentData: []),
              )
        ],
      ),
    );
  }
}
