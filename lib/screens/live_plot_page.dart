// live_plot_page.dart
import 'dart:math';

import 'package:baby_monitoring_app/screens/first_screen.dart';
import 'package:baby_monitoring_app/screens/static_plot_page.dart';
import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/graph.dart';

class LivePlotPage extends StatelessWidget {
  const LivePlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the app state and graph names
    final appState = context.read<AppStateProvider>();
    final channelNames = appState.channelNames;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5), 
                spreadRadius: 1, 
                blurRadius: 10, 
                offset: const Offset(0, 3), 
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
            leading: IconButton( // Added back button for navigating back to home
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Goes back to the previous page
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate to the static plot page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StaticPlotPage()),
                  );
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
                icon: const Icon(Icons.home, color: Colors.white, size: 50),
                onPressed: () {
                  // Navigate back to the home page
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const FirstScreen()),
                    (Route<dynamic> route) => false, // Clears the navigation stack
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          for (int i = 0; i < channelNames.length; i++)
            if (i == 0) 
              Expanded(
                child: GraphWidget(number: 1, data: [], paramName: channelNames[i], lineColor: Colors.red, plotType: 's', commentData: []),
              )
            else if (i == 1)
              Expanded(
                child: GraphWidget(number: 1, data: [], paramName: channelNames[i], lineColor: Colors.green, plotType: 's', commentData: []),
              )
            else
              Expanded(
                child: GraphWidget(number: i + 1, data: [], paramName: channelNames[i], lineColor: generateRandomColor(), plotType: 's', commentData: []),
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
