// live_plot_page.dart
import 'dart:math';
import 'package:baby_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';
import '../widgets/data_model.dart';
import '../widgets/graph.dart';

class LivePlotPage extends StatelessWidget {
  const LivePlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final List<String> channelNames = appState.channelNames;
    final Map<String, List<ChartData>> channelData =
        appState.channelData; // auto gen data for now
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
                  // Static Plot goes here
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.palePink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: AppColors.darkPink, width: 1.5),
                  ),
                ),
                child: const Text('Make plots static',
                    style: TextStyle(color: Colors.black, fontSize: 15.0)),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.white, size: 50),
                onPressed: () => _showPopupMenu(context),
              ),
            ],
          ),
        ),
      ),
      body: channelNames.isNotEmpty
          ? Column(
              children: channelNames.map((currentChannel) {
                final int index = channelNames.indexOf(currentChannel);
                final List<ChartData>? currentData =
                    channelData[currentChannel];

                if (currentData == null) {
                  return Center(
                    child: Text(
                      'No data available for $currentChannel',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return Expanded(
                  child: GraphWidget(
                    number: index + 1,
                    paramName: currentChannel,
                    data: generateRandomData(10),
                    lineColor: _getChannelColor(currentChannel),
                    plotType: 'l',
                  ),
                );
              }).toList(),
            )
          : const Center(
              child: Text(
                'No channels available. Please add a channel.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    await showMenu<String>(
      context: context,
      position:
          RelativeRect.fromLTRB(200.0, 80.0, 0.0, 0.0), //IconButton position
      items: [
        PopupMenuItem<String>(
          value: 'past_recordings',
          onTap: () {
            Navigator.pushNamed(
                context, '/pastRecordings'); // Navigation to past recordings
          },
          child: const Text(
            'Go to past recordings',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  Color _getChannelColor(String paramName) {
    switch (paramName) {
      case 'glucose':
        return Colors.green;
      case 'lactate':
        return Colors.red;
      default:
        return _generateRandomColor();
    }
  }

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255, // Fully opaque
      random.nextInt(256), // Random red value (0-255)
      random.nextInt(256), // Random green value (0-255)
      random.nextInt(256), // Random blue value (0-255)
    );
  }
}

List<ChartData> generateRandomData(int count) {
  final Random random = Random();
  final DateTime startTime = DateTime.now();

  return List<ChartData>.generate(count, (index) {
    final DateTime time =
        startTime.add(Duration(seconds: index * 5)); // 5-second intervals
    final double value = 50.0 +
        random.nextDouble() * 50.0; // Random value between 50.0 and 100.0
    return ChartData(time, value);
  });
}
