//import 'package:baby_monitoring_app/widgets/comment_popup.dart';
import 'package:baby_monitoring_app/widgets/data_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'comment_popup.dart';

// This class is the base unit for all the plots. It can be used for both live plotting and static plotting
class GraphWidget extends StatefulWidget {
  final int number; // The plot number
  final List<ChartData> data; // data used for the plot
  final String paramName; // 
  final Color lineColor;

  const GraphWidget({
    super.key,
    required this.number,
    required this.data,
    required this.paramName,
    required this.lineColor,
  });

    @override
    GraphWidgetState createState() => GraphWidgetState();
}

class GraphWidgetState extends State<GraphWidget> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltipBehavior;
  late DateTimeAxis _xAxis;
  final ValueNotifier<List<CartesianChartAnnotation>> annotations = ValueNotifier<List<CartesianChartAnnotation>>([]);

  @override
  void initState() {
    super.initState();

    // Initialize TooltipBehavior
    _tooltipBehavior = TooltipBehavior(enable: true);

    // Initialize ZoomPanBehavior
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true, // Enable pinching to zoom
      //enableDoubleTapZooming: true, // Enable double-tap zooming
      enablePanning: true, // Enable scrolling
      enableSelectionZooming: true,
      zoomMode: ZoomMode.x, // Allow horizontal scrolling only
    );

    _xAxis = DateTimeAxis(
      title: const AxisTitle(text: 'Time of Day'),
      enableAutoIntervalOnZooming: true,
      edgeLabelPlacement: EdgeLabelPlacement.shift, //prevents time labels at edges from being cut off
      initialVisibleMinimum: widget.data.last.time.subtract(const Duration(minutes: 5)), // Intially show post recent 5 minutes of data
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
                      annotations: annotations,
                    ),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder<List<CartesianChartAnnotation>>(
            valueListenable: annotations, 
            builder: (BuildContext context, List<CartesianChartAnnotation> annotationList, Widget? child) {
              return SizedBox(
                height: 200,
                child: GestureDetector(
                  onDoubleTapDown: (details) {
                    final RenderBox box = context.findRenderObject() as RenderBox;

                    final widgetWidth = box.size.width;

                    final x = details.localPosition.dx;

                    final dataPoint = _getDataPointFromX(x, widgetWidth, _xAxis, widget.data);

                    _showCommentPopup(context, dataPoint, annotations);
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
                    annotations: annotations.value,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ExpandedGraphPage Class (added here)
class ExpandedGraphPage extends StatefulWidget {
  final List<ChartData> data;
  final String paramName;
  final Color lineColor;
  final ValueNotifier<List<CartesianChartAnnotation>> annotations;

  const ExpandedGraphPage({
    super.key,
    required this.data,
    required this.paramName,
    required this.lineColor,
    required this.annotations,
  });

  @override
  ExpandedGraphPageState createState() => ExpandedGraphPageState();
}

class ExpandedGraphPageState extends State<ExpandedGraphPage> {
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
      //enableDoubleTapZooming: true, // Enable double-tap zooming
      enablePanning: true, // Enable scrolling
      enableSelectionZooming: true,
      zoomMode: ZoomMode.x, // Allow horizontal scrolling only
    );

    _xAxis = DateTimeAxis(
      title: const AxisTitle(text: 'Time of Day'),
      enableAutoIntervalOnZooming: true,
      edgeLabelPlacement: EdgeLabelPlacement.shift, //prevents time labels at edges from being cut off
      initialVisibleMinimum: widget.data.last.time.subtract(const Duration(minutes: 5)), // Intially show post recent 5 minutes of data
      initialVisibleMaximum: widget.data.last.time, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expanded Graph - ${widget.paramName}')),
      body: Center(
        child: ValueListenableBuilder<List<CartesianChartAnnotation>>(
          valueListenable: widget.annotations, 
          builder: (BuildContext context, List<CartesianChartAnnotation> annotationList, Widget? child) {
            

            return GestureDetector(
              onDoubleTapDown: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;

                final widgetWidth = box.size.width;

                final x = details.localPosition.dx;

                final dataPoint = _getDataPointFromX(x, widgetWidth, _xAxis, widget.data);

               _showCommentPopup(context, dataPoint, widget.annotations);
              },
              child: SfCartesianChart(
                legend: const Legend(isVisible: true),
                tooltipBehavior: _tooltipBehavior, //enabling tooltips
                zoomPanBehavior:_zoomPanBehavior, //enabling zooming and panning
                primaryXAxis: _xAxis,
                series: <LineSeries<ChartData, DateTime>>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: widget.data,
                    color: widget.lineColor,
                    enableTooltip: true,
                    xValueMapper: (ChartData data, _) => data.time,
                    yValueMapper: (ChartData data, _) => data.bitVal,
                    animationDuration: 0,
                  ),
                ],
                annotations: widget.annotations.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

ChartData _getDataPointFromX(double x, double width, DateTimeAxis axis, List<ChartData> data) {
  final xMin = axis.initialVisibleMinimum!; // Error handle
  final xMax = axis.initialVisibleMaximum!; // Error handle

  final xMinIndex = _getIndexFromTime(data, xMin.toString());
  final xMaxIndex = _getIndexFromTime(data, xMax.toString());

  final numPoints = xMaxIndex - xMinIndex + 1;

  final xProportion = x / width;

  final index = xMinIndex + (numPoints * xProportion).floor();

  return data[index];
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

void _showCommentPopup(BuildContext context, ChartData dataPoint, ValueNotifier<List<CartesianChartAnnotation>> annotations) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CommentPopup(time: dataPoint.time, bitVal: dataPoint.bitVal, annotations: annotations);
    },
  );
}