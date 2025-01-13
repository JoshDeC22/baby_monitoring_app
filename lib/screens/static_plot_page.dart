// live_plot_page.dart
import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/data_model.dart';
import '../widgets/graph.dart';

class StaticPlotPage extends StatelessWidget {
  const StaticPlotPage({super.key});


  @override
  Widget build(BuildContext context) {
    // Get the app state and static data
    final appState = Provider.of<AppStateProvider>(context);
    

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