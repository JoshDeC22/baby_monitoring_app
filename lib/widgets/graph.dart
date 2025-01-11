//import 'package:baby_monitoring_app/widgets/comment_popup.dart';
import 'package:baby_monitoring_app/widgets/data_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/annotation_provider.dart';
import 'package:provider/provider.dart';

class GraphWidget extends StatefulWidget {
  final int number;
  final List<ChartData> data;
  final String paramName;
  final Color lineColor;

  const GraphWidget({
    super.key,
    required this.number,
    required this.data,
    required this.paramName,
    required this.lineColor,
  });

    @override
    _GraphWidgetState createState() => _GraphWidgetState();
}

class GraphWidgetState extends State<GraphWidget> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltipBehavior;
  late DateTimeAxis _xAxis;

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

    _xAxis = DateTimeAxis(
      title: const AxisTitle(text: 'Time of Day'),
      enableAutoIntervalOnZooming: true,
      edgeLabelPlacement: EdgeLabelPlacement.shift, //prevents time labels at edges from being cut off
      initialVisibleMinimum: widget.data.last.time.subtract(Duration(minutes: 5)), // Intially show post recent 5 minutes of data
      initialVisibleMaximum: widget.data.last.time, 
    );
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text('Graph ${widget.number} - ${widget.paramName}'),
            trailing: IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpandedGraphPage(
                      data: widget.data,
                      paramName: widget.paramName,
                      lineColor: widget.lineColor,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 200,
            child: GestureDetector(
              onDoubleTapDown: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;

                final widgetWidth = box.size.width;

                final x = details.localPosition.dx;

                final _dataPoint = _getDataPointFromX(x, widgetWidth);

                //_showCommentPopup(context, dataPoint);
              },
              child: SfCartesianChart(
                legend: const Legend(isVisible: true),
                tooltipBehavior: _tooltipBehavior, //enabling tooltips
                zoomPanBehavior:
                    _zoomPanBehavior, //enabling zooming and panning
                primaryXAxis: _xAxis,
                series: <LineSeries<ChartData, DateTime>>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: widget.data,
                    color: widget.lineColor,
                    enableTooltip: true,
                    xValueMapper: (ChartData data, _) => data.time,
                    yValueMapper: (ChartData data, _) => data.bitVal,
                  ),
                ],
                annotations: annotations,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _showCommentPopup(BuildContext context, ChartData dataPoint) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CommentPopup(time: dataPoint.time, bitVal: dataPoint.bitVal);
  //     },
  //   );
  // }

  ChartData _getDataPointFromX(double x, double width) {
    final xMin = _xAxis.minimum!; // Error handle
    final xMax = _xAxis.maximum!; // Error handle

    final xMinIndex = _getIndexFromTime(widget.data, xMin.toString());
    final xMaxIndex = _getIndexFromTime(widget.data, xMax.toString());

    final numPoints = xMaxIndex - xMinIndex + 1;

    final xProportion = x / width;

    final index = xMinIndex + (numPoints * xProportion).floor();

    return widget.data[index];
  }

  int _getIndexFromTime(List<ChartData> data, String time) {
    int index = 0;

    for (int i = 0; i < data.length; i++) {
      String dataPointTime = data[i].time.toString();

      if (dataPointTime == time) {
        index = i;
        break;
      }
    }

    return index;
  }
}

// ExpandedGraphPage Class (added here)
class ExpandedGraphPage extends StatefulWidget {
  final List<ChartData> data;
  final String paramName;
  final Color lineColor;

  const ExpandedGraphPage({
    super.key,
    required this.data,
    required this.paramName,
    required this.lineColor,
  });

  @override
  ExpandedGraphPageState createState() => ExpandedGraphPageState();
}

class ExpandedGraphPageState extends State<ExpandedGraphPage> {
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
    return Scaffold(
      appBar: AppBar(title: Text('Expanded Graph - ${widget.paramName}')),
      body: Center(
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior, //enabling tooltips
          zoomPanBehavior: _zoomPanBehavior, //enabling zooming and panning
          primaryXAxis: DateTimeAxis(
            title: const AxisTitle(text: 'Time of Day'),
            enableAutoIntervalOnZooming: true,
            edgeLabelPlacement: EdgeLabelPlacement.shift, //prevents time labels at edges from being cut off
            initialVisibleMinimum: widget.data.last.time.subtract(Duration(minutes: 5)), // Intially show post recent 5 minutes of data
            initialVisibleMaximum: widget.data.last.time,
          ),
          series: <LineSeries<ChartData, DateTime>>[
            LineSeries<ChartData, DateTime>(
              dataSource: widget.data,
              color: widget.lineColor,
              xValueMapper: (ChartData data, _) => data.time,
              yValueMapper: (ChartData data, _) => data.bitVal,
            ),
          ],
        ),
      ),
    );
  }
}
