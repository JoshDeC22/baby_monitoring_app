// graph_item.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'data_model.dart';

class GraphItem extends StatelessWidget {
  final int number;
  final String plotType;
  final List<ChartData> data;

  const GraphItem(
      {super.key,
      required this.number,
      required this.plotType,
      required this.data});

  @override
  Widget build(BuildContext context) {
    final Color lineColor = (plotType == 'glucose') ? Colors.red : Colors.green;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text('Graph $number - $plotType'),
            trailing: IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpandedGraphPage(
                      data: data,
                      plotType: plotType,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <LineSeries<ChartData, DateTime>>[
                LineSeries<ChartData, DateTime>(
                  dataSource: data,
                  color: lineColor,
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.bitVal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ExpandedGraphPage Class (added here)
class ExpandedGraphPage extends StatelessWidget {
  final List<ChartData> data;
  final String plotType;

  const ExpandedGraphPage(
      {super.key, required this.data, required this.plotType});

  @override
  Widget build(BuildContext context) {
    final Color lineColor = (plotType == 'glucose') ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(title: Text('Expanded Graph - $plotType')),
      body: Center(
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(),
          series: <LineSeries<ChartData, DateTime>>[
            LineSeries<ChartData, DateTime>(
              dataSource: data,
              color: lineColor,
              xValueMapper: (ChartData data, _) => data.time,
              yValueMapper: (ChartData data, _) => data.bitVal,
            ),
          ],
        ),
      ),
    );
  }
}
