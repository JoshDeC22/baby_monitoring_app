// live_plot_page.dart
import 'package:baby_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';
import '../utils/data_model.dart';
import '../widgets/graph.dart';

class LivePlotPage extends StatelessWidget {
  const LivePlotPage({super.key});


  @override
  Widget build(BuildContext context) {
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
              'Real-time Blood Parameter Monitoring',
              style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.darkBlue, 
            centerTitle: true,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Idk 
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.palePink, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), 
                    side: BorderSide(color: AppColors.darkPink, width: 1.5), 
                  ),
                ),
                child: const Text('Make plots static', style: TextStyle(color: Colors.black, fontSize: 15.0)),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 50),
                onPressed: () => _showPopupMenu(context),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GraphWidget(number: 1, paramName: 'glucose', data: glucoseData, lineColor: Colors.green, plotType: 'l'),
          ),
          Expanded(
            child: GraphWidget(number: 2, paramName: 'lactate', data: lactateData, lineColor: Colors.red, plotType: 'l'),
          ),
        ],
      ),
    );
  }
}
 void _showPopupMenu(BuildContext context) async {
    await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(200.0, 80.0, 0.0, 0.0), //IconButton position
      items: [
        PopupMenuItem<String>(
          value: 'past_recordings',
          onTap: () {
            Navigator.pushNamed(context, '/pastRecordings'); // Navigation to past recordings
          },
          child: 
          const Text('Go to past recordings',
          textAlign: TextAlign.center, 
          style: TextStyle(fontSize: 18), 
          ),
        ),
      ],
      elevation: 8.0,
    );
  }


final List<ChartData> glucoseData = [
  ChartData(DateTime.now(), 4),
  ChartData(DateTime.now().add(const Duration(minutes: 1)), 5),
  ChartData(DateTime.now().add(const Duration(minutes: 2)), 4),
  ChartData(DateTime.now().add(const Duration(minutes: 3)), 5),
];

final List<ChartData> lactateData = [
  ChartData(DateTime.now(), 1),
  ChartData(DateTime.now().add(const Duration(minutes: 1)), 1),
];