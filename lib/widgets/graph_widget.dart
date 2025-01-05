import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../blood_data.dart';

class graph_widget extends StatefulWidget {
  final String parameterName; // blood parameter to plot
  final Color lineColor; 
  final List<BloodData> graphData; //data previously loaded from a CSV file

  const graph_widget({
    super.key,
    required this.parameterName,
    required this.lineColor,
    required this.graphData,
  });

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<graph_widget> { 
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();

    // Initialize TooltipBehavior
    _tooltipBehavior = TooltipBehavior(enable: true);

    // Initialize ZoomPanBehavior
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true, // Enable pinching to zoom
      enableDoubleTapZooming: true, // Enable double-tap zooming
      enablePanning: true, // Enable scrolling
      enableSelectionZooming: true,
      zoomMode: ZoomMode.x, // Allow horizontal scrolling only
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Adds space/padding around the card
        child: Card(
          elevation: 10, // Adds a shadow around the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0), // Padding inside the card
            //height: 400, // fix
            child: SfCartesianChart(
              title: ChartTitle(text: '${widget.parameterName} levels over time'),
              legend: Legend(isVisible: true),
              tooltipBehavior: _tooltipBehavior, //enabling tooltips
              zoomPanBehavior: _zoomPanBehavior, //enabling zooming anf panning
              series: <LineSeries<BloodData, DateTime>>[
                LineSeries<BloodData, DateTime>(
                  dataSource: widget.graphData,
                  name: '${widget.parameterName}',
                  xValueMapper: (BloodData data, _) => data.time, //x-axis -> time of day
                  yValueMapper: (BloodData data, _) => data.bloodVal, //y-axis -> blood concentration
                  color: widget.lineColor,
                  enableTooltip: true,
                ),
              ],
              primaryXAxis: DateTimeAxis(
                title: AxisTitle(text: 'Time Of Day'),
                intervalType: DateTimeIntervalType.minutes, // interval set to 1 minute
                interval: 1, 
                enableAutoIntervalOnZooming: true, // Adjust intervals when zooming
                edgeLabelPlacement: EdgeLabelPlacement.shift, //prevents time labels at edges from being cut off
                initialVisibleMinimum: widget.graphData.last.time.subtract(Duration(minutes: 5)), // Intially show post recent 5 minutes of data
                initialVisibleMaximum: widget.graphData.last.time, 
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: '${widget.parameterName} (mmol/L)'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
