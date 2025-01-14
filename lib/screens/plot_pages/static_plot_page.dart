// live_plot_page.dart
import 'dart:math';

import 'package:baby_monitoring_app/screens/first_screen.dart'; // Import the home screen
import 'package:baby_monitoring_app/utils/state_management/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/graph.dart';

class StaticPlotPage extends StatelessWidget {
  const StaticPlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the app state and static data
    final appState = context.read<AppStateProvider>();
    final comments = appState.staticCommentData;
    final data = appState.staticData;
    final names = appState.channelNames;

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
              style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.darkBlue, 
            centerTitle: true,
            leading: IconButton( // Added back button to AppBar
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Navigates back to the previous page
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // clear the app state and navigate back to the home screen
                  final appState = context.read<AppStateProvider>();
                  appState.clearAppState();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false, // Clear all previous routes
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.palePink, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), 
                    side: BorderSide(color: AppColors.darkPink, width: 1.5), 
                  ),
                ),
                child: const Text('Go Home', style: TextStyle(color: Colors.black, fontSize: 15.0)),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 50),
                onPressed: () {
                  // clear the app state and navigate back to the home screen
                  final appState = context.read<AppStateProvider>();
                  appState.clearAppState();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false, // Clear all previous routes
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          for (int i = 0; i < data.length; i++)
            if (i == 0) 
              Flexible(
                child: GraphWidget(number: 1, data: data[i], paramName: names[i], lineColor: Colors.red, plotType: 's', commentData: comments),
              )
            else if (i == 1)
              Flexible(
                child: GraphWidget(number: 1, data: data[i], paramName: names[i], lineColor: Colors.green, plotType: 's', commentData: comments),
              )
            else
              Flexible(
                child: GraphWidget(number: i + 1, data: data[i], paramName: names[i], lineColor: generateRandomColor(), plotType: 's', commentData: comments),
              )
        ],
      ),
    );
  }
}

Color generateRandomColor() {
  final random = Random();
  return Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
}
