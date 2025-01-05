
// graph_item.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'data_model.dart';

class GraphItem extends StatelessWidget {
  final int number;
  final String plotType;

  const GraphItem({super.key, required this.number, required this.plotType});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> data = [
      ChartData(DateTime.now(), 4.5),
      ChartData(DateTime.now().add(const Duration(minutes: 1)), 5.0),
    ];

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
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text('Expanded Graph $number - $plotType')),
                      body: Center(
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(),
                          series: <LineSeries<ChartData, DateTime>>[
                            LineSeries<ChartData, DateTime>(
                              dataSource: data,
                              color: lineColor,
                              xValueMapper: (ChartData data, _) => data.time,
                              yValueMapper: (ChartData data, _) => data.value,
                            ),
                          ],
                        ),
                      ),
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
                  yValueMapper: (ChartData data, _) => data.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}