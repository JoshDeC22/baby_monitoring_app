import 'package:baby_monitoring_app/widgets/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'comment_popup.dart';

class GraphWidget extends StatefulWidget {
  final int number; // The plot number
  final List<ChartData> data; // data used for the plot
  final String
      paramName; // the name of the parameter that is being graphed (e.g. Glucose)
  final Color lineColor; // the color of the line
  final String plotType; // either 's' or 'l' for static or live

  // Constructor
  const GraphWidget({
    super.key,
    required this.number,
    required this.data,
    required this.paramName,
    required this.lineColor,
    required this.plotType,
  });

  // This is a stateful widget so the widget state is created here
  @override
  GraphWidgetState createState() => GraphWidgetState();
}

// This class manages the state of the GraphWidget class it is where all the actual widgets contained within GraphWidget
// get specified.
class GraphWidgetState extends State<GraphWidget> {
  late ZoomPanBehavior _zoomPanBehavior; // controller for zooming
  late TooltipBehavior _tooltipBehavior; // controller for interacting with plot
  late DateTimeAxis
      _xAxis; // the x axis here is created when the state is created since it will be the same for any type of plot
  late RustStreamSink<int>?
      dataStream; // if the plot is live this is the data source
  late DateTimeAxisController
      _axisController; // controller to retrieve information about the x axis
  // This value notifier allows for the chart to dynamically update when annotations are added
  final ValueNotifier<List<CartesianChartAnnotation>> annotations =
      ValueNotifier<List<CartesianChartAnnotation>>([]);

  // this function runs when the state is created
  @override
  void initState() {
    super.initState();

    // Initialize TooltipBehavior
    _tooltipBehavior = TooltipBehavior(enable: true);

    // Initialize ZoomPanBehavior
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true, // Enable pinching to zoom
      enablePanning: true, // Enable scrolling
      enableSelectionZooming: true, // Enable selection zooming
      zoomMode: ZoomMode.x, // Allow horizontal scrolling only
    );

    // Create the x axis for the plot as an axis of DateTimes
    _xAxis = DateTimeAxis(
      title: const AxisTitle(text: 'Time of Day'), // axis title
      enableAutoIntervalOnZooming: true, // updates the axis when zooming
      edgeLabelPlacement: EdgeLabelPlacement
          .shift, //prevents time labels at edges from being cut off
      initialVisibleMinimum: widget.data.last.time.subtract(const Duration(
          minutes: 5)), // Intially show post recent 5 minutes of data
      initialVisibleMaximum:
          widget.data.last.time, // Initially show the last data point
      // initialize the controller for this axis
      onRendererCreated: (DateTimeAxisController controller) {
        _axisController = controller;
      },
    );

    // Initialize stream sink - get real data later
    dataStream = widget.plotType == 's' ? null : null;
  }

  // this function builds the graph widget
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Gives card elevation
      margin: const EdgeInsets.all(8.0), // Gives the margin of the card
      child: Column(
        children: [
          // this ListTile shows the title of the graph as well as the button to go to the expanded graph view
          ListTile(
            title: Text(
                'Graph ${widget.number} - ${widget.paramName}'), // Title of the graph
            // Create the button to go to the expanded graph view
            trailing: IconButton(
              icon: const Icon(Icons.fullscreen), // define the icon
              // runs when the button is pressed
              onPressed: () {
                // Navigate to the expanded graph page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Create the expanded graph page
                    builder: (context) => ExpandedGraphPage(
                      data: widget.data,
                      paramName: widget.paramName,
                      lineColor: widget.lineColor,
                      annotations: annotations,
                      plotType: widget.plotType,
                    ),
                  ),
                );
              },
            ),
          ),
          // Wrap the SfCartesianChart in a ValueListenableBuilder and GestureDetector to allow add annotations on a double click
          ValueListenableBuilder<List<CartesianChartAnnotation>>(
            valueListenable:
                annotations, // Listen for updates to the annotations list
            builder: (BuildContext context,
                List<CartesianChartAnnotation> annotationList, Widget? child) {
              return SizedBox(
                height: 200, // height of the sized box
                // This GestureDetector runs whenever the plot is double clicked
                child: GestureDetector(
                  onDoubleTapDown: (details) {
                    final RenderBox box = context.findRenderObject()
                        as RenderBox; // Get the box the chart is contained within

                    final widgetWidth =
                        box.size.width; // find the pixel width of the chart

                    final x = details.localPosition
                        .dx; // get the pixel position of the click

                    final dataPoint = _getDataPointFromX(
                        x,
                        widgetWidth,
                        _axisController,
                        widget.data); // get the closest data point to the click

                    _showCommentPopup(context, dataPoint,
                        annotations); // Show the popup to enter the comment
                  },
                  // Create the SfCartesianChart
                  child: _createPlot(
                      dataStream,
                      widget.lineColor,
                      widget.data,
                      _xAxis,
                      annotations,
                      widget.plotType,
                      _tooltipBehavior,
                      _zoomPanBehavior),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// This class is for when the user wants to expand a particular graph in the list
class ExpandedGraphPage extends StatefulWidget {
  final List<ChartData> data; // Data used for the plot
  final String
      paramName; // the name of the parameter that is being graphed (e.g. Glucose)
  final Color lineColor; // the line color of the graph
  // This value notifier allows for the chart to dynamically update when annotations are added
  final ValueNotifier<List<CartesianChartAnnotation>> annotations; //
  final String plotType; // the plot type either 's' or 'l' for static or live

  // the constructor for this class
  const ExpandedGraphPage({
    super.key,
    required this.data,
    required this.paramName,
    required this.lineColor,
    required this.annotations,
    required this.plotType,
  });

  // Since this is a stateful widget, the state of the widget needs to be created
  @override
  ExpandedGraphPageState createState() => ExpandedGraphPageState();
}

// This class manages the state of the ExpandedGraphPage
class ExpandedGraphPageState extends State<ExpandedGraphPage> {
  late ZoomPanBehavior _zoomPanBehavior; // controller for zooming
  late TooltipBehavior
      _tooltipBehavior; // controller for interacting with the plot
  late DateTimeAxis
      _xAxis; // the x axis here is created when the state is created since it will be the same for any type of plot
  late DateTimeAxisController
      _axisController; // controller to retrieve information about the x axis
  late RustStreamSink<int>?
      dataStream; // if the plot is live this is the data source

  @override
  void initState() {
    super.initState();

    // Initialize TooltipBehavior
    _tooltipBehavior = TooltipBehavior(enable: true);

    // Initialize ZoomPanBehavior
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true, // Enable pinching to zoom
      enablePanning: true, // Enable scrolling
      enableSelectionZooming: true, // Enable selection zooming
      zoomMode: ZoomMode.x, // Allow horizontal scrolling only
    );

    // Initialize the x axis for the plot as a DateTimeAxis
    _xAxis = DateTimeAxis(
      title: const AxisTitle(text: 'Time of Day'), // axis title
      enableAutoIntervalOnZooming: true, // changes the axis labels when zooming
      edgeLabelPlacement: EdgeLabelPlacement
          .shift, //prevents time labels at edges from being cut off
      initialVisibleMinimum: widget.data.last.time.subtract(const Duration(
          minutes: 5)), // Intially show post recent 5 minutes of data
      initialVisibleMaximum: widget.data.last
          .time, // Initially make the visible maximum the last data point
      // Initialize the axis controller
      onRendererCreated: (DateTimeAxisController controller) {
        _axisController = controller;
      },
    );

    // Find some way of initializing the data stream
    dataStream = widget.plotType == 's' ? null : null;
  }

  // Build the widgets contained within the ExpandedGraphPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Expanded Graph - ${widget.paramName}')), // Title of the graph
      body: Center(
        // Wrap the plot with a ValueListenableBuilder and GestureDetector to add annotations dynamically on a double click
        child: ValueListenableBuilder<List<CartesianChartAnnotation>>(
          valueListenable:
              widget.annotations, // Listen for updates to the annotations list
          builder: (BuildContext context,
              List<CartesianChartAnnotation> annotationList, Widget? child) {
            // GestureDetector detects when the plot is double clicked to add an annotation
            return GestureDetector(
              onDoubleTapDown: (details) {
                final RenderBox box = context.findRenderObject()
                    as RenderBox; // Get the box that the plot is contained within

                final widgetWidth =
                    box.size.width; // get the width of the chart in pixels

                final x = details.localPosition
                    .dx; // get the x location of the double click in pixels

                final dataPoint = _getDataPointFromX(
                    x,
                    widgetWidth,
                    _axisController,
                    widget
                        .data); // find the closest data point to the double click

                _showCommentPopup(
                    context,
                    dataPoint,
                    widget
                        .annotations); // Show the popup to enter the annotation
              },
              // Create the SfCartesianChart
              child: _createPlot(
                  dataStream,
                  widget.lineColor,
                  widget.data,
                  _xAxis,
                  widget.annotations,
                  widget.plotType,
                  _tooltipBehavior,
                  _zoomPanBehavior),
            );
          },
        ),
      ),
    );
  }
}

// This function finds the closest data point to a double click
ChartData _getDataPointFromX(double x, double width,
    DateTimeAxisController axisController, List<ChartData> data) {
  // Get the visible minimum and maximum DateTime values on the x axis
  final xMin = axisController.visibleMinimum!;
  final xMax = axisController.visibleMaximum!;

  // Get the index of those values in the data list
  final xMinIndex = _getIndexFromTime(data, xMin.toString());
  final xMaxIndex = _getIndexFromTime(data, xMax.toString());

  final numPoints = xMaxIndex -
      xMinIndex +
      1; // Find the number of data points within the visible axis

  final xProportion =
      x / width; // get the proportional position of the double click

  final index = xMinIndex +
      (numPoints * xProportion)
          .floor(); // Find the closest index to the double click

  return data[index]; // return the data at that index
}

// This function gets the index of a data point based on the time value
int _getIndexFromTime(List<ChartData> data, String time) {
  int index = 0; // initial index

  // loop through the data list and find the index of the first element that matches the time
  for (int i = 0; i < data.length; i++) {
    String dataPointTime = data[i].time.toString();

    if (dataPointTime == time) {
      index = i;
      break;
    }
  }

  return index; // return the index
}

// This function shows the popup to enter the annotation when the user double clicks
void _showCommentPopup(BuildContext context, ChartData dataPoint,
    ValueNotifier<List<CartesianChartAnnotation>> annotations) {
  // shows the dialog box/popup
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CommentPopup(
          time: dataPoint.time,
          bitVal: dataPoint.bitVal,
          annotations: annotations);
    },
  );
}

// This function creates the SfCartesianChart based on whether the plot is live or static.
// If the plot is static then it returns the SfCartesianChart as normal. If it is live the
// function wraps the SfCartesianChart in a StreamBuilder that handles dynamic updates to the
// data list.
Widget _createPlot(
    RustStreamSink<int>? dataStream,
    Color lineColor,
    List<ChartData> data,
    DateTimeAxis xAxis,
    ValueNotifier<List<CartesianChartAnnotation>> annotations,
    String plotType,
    TooltipBehavior tooltipBehavior,
    ZoomPanBehavior zoomPanBehavior) {
  double animationDuration = plotType == "s"
      ? 0
      : 0.1; // set the animation duration to 0 if the plot is static and 0.1 if it is live

  // create the SfCartesianChart for both live and static
  SfCartesianChart plotWidget = SfCartesianChart(
    legend: const Legend(isVisible: true), // add a plot legend
    tooltipBehavior: tooltipBehavior, //enabling tooltips
    zoomPanBehavior: zoomPanBehavior, //enabling zooming and panning
    primaryXAxis: xAxis, // set the x axis
    // Create the line showing the data
    series: <LineSeries<ChartData, DateTime>>[
      LineSeries<ChartData, DateTime>(
        dataSource: data, // set the data source
        color: lineColor, // set the line color
        enableTooltip: true, // allow plot interaction
        // map the data so that the time is shown on the x axis and the value
        // from the bluetooth device is shown on the y axis
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.bitVal,
        animationDuration: animationDuration, // set the animation duration
      ),
    ],
    annotations: annotations
        .value, // set the annotations (that can be updated dynamically)
  );

  // if the plot is static then just return the plotWidget, if it is live then wrap it in a StreamBuilder
  if (plotType == 's') {
    return plotWidget;
  } else {
    return StreamBuilder<int>(
        stream: dataStream!.stream, // set the data stream
        builder: (context, snap) {
          // whenever data is sent from rust, add it to the data list and return the plotWidget
          if (snap.hasData) {
            final y = snap.data!;
            final x = DateTime.now();
            data.add(ChartData(x, y));
          }

          return plotWidget;
        });
  }
}
