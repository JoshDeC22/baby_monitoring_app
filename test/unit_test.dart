import 'dart:io';
import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/utils/state_management/app_state_provider.dart';
import 'package:baby_monitoring_app/widgets/comment_popup.dart';
import 'package:baby_monitoring_app/utils/data_wrappers/chart_data.dart';
import 'package:baby_monitoring_app/widgets/graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:baby_monitoring_app/src/rust/frb_generated.dart';

main() async {
  await RustLib.init();

  // Dummy Data
  DateTime dummyTime = DateTime.parse('2025-01-01 11:00:00'); // Year/Month/Day
  final List<ChartData> dummyData = [
    ChartData(dummyTime, 4),
    ChartData(dummyTime.add(const Duration(minutes: 1)), 5),
    ChartData(dummyTime.add(const Duration(minutes: 2)), 4),
    ChartData(dummyTime.add(const Duration(minutes: 3)), 5),
    ChartData(dummyTime.add(const Duration(minutes: 4)), 2),
    ChartData(dummyTime.add(const Duration(minutes: 5)), 1),
    ChartData(dummyTime.add(const Duration(minutes: 6)), 3),
    ChartData(dummyTime.add(const Duration(minutes: 7)), 2),
    ChartData(dummyTime.add(const Duration(minutes: 8)), 4),
    ChartData(dummyTime.add(const Duration(minutes: 9)), 6),
    ChartData(dummyTime.add(const Duration(hours: 1)), 3),
  ];

  group("WidgetTest", () {
    // Fullscreen Test
    testWidgets("Graph Should be Able to Fullscreen",
        (WidgetTester tester) async {
      // Create a Test GraphItem Widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GraphWidget(
                number: 1,
                data: dummyData,
                paramName: 'glucose',
                lineColor: Colors.green,
                plotType: 's',
                commentData: []),
          ),
        ),
      );

      // Tap the Fullscreen Icon
      await tester.tap(find.byIcon(Icons.fullscreen));
      await tester.pumpAndSettle();

      // Checks if Expanded Graph Appears
      expect(find.byType(ExpandedGraphPage), findsOneWidget,
          reason:
              'The ExtendedGraphPage Widget Should Appear When Fullscreened');
    });

    // Scrolling Test
    testWidgets("Graph Should be Able to Scroll", (WidgetTester tester) async {
      // Create a Test GraphItem Widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GraphWidget(
                number: 1,
                data: dummyData,
                paramName: 'glucose',
                lineColor: Colors.green,
                plotType: 's',
                commentData: []),
          ),
        ),
      );

      // Wait for the Chart to Properly Initiallize
      await tester.pumpAndSettle();

      // Get the AxisController for the Chart
      final graphWidgetState =
          tester.state(find.byType(GraphWidget)) as GraphWidgetState;
      final axisController = graphWidgetState.axisController;

      // The Maximum Time on the Axis should be the latest Time Point Entry
      expect(axisController.visibleMaximum,
          dummyTime.add(const Duration(hours: 1)));

      // Scoll Left
      await tester.fling(
          find.byType(SfCartesianChart), const Offset(200, 0), 100);
      await tester.pumpAndSettle();

      // Expects the Maximum Time is less than 12:00
      expect(
          axisController.visibleMaximum
              ?.isBefore(dummyTime.add(const Duration(hours: 1))),
          isTrue);
    });

    // Zooming Test
    testWidgets("Graph Should be Able to Zoom in and out",
        (WidgetTester tester) async {
      // Create a Test GraphItem Widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GraphWidget(
                number: 1,
                data: dummyData,
                paramName: 'glucose',
                lineColor: Colors.green,
                plotType: 's',
                commentData: []),
          ),
        ),
      );

      // Wait for the Chart to Properly Initiallize
      await tester.pumpAndSettle();

      // Get the AxisController for the Chart
      final graphWidgetState =
          tester.state(find.byType(GraphWidget)) as GraphWidgetState;
      final axisController = graphWidgetState.axisController;

      // Get initial minimum and maximum axis values
      DateTime initialMinimumVisible =
          axisController.visibleMinimum as DateTime;
      DateTime initialMaximumVisible =
          axisController.visibleMaximum as DateTime;

      // Initial Zoom should be 5 Minutes
      expect(initialMaximumVisible.difference(initialMinimumVisible),
          const Duration(minutes: 5));

      // Get the center of the chart
      final Offset center = tester.getCenter(find.byType(SfCartesianChart));

      // Create Two Gesture Objects
      final touch1 = await tester.startGesture(center.translate(-10, 0));
      final touch2 = await tester.startGesture(center.translate(10, 0));

      // Zoom In
      await touch1.moveBy(const Offset(-15, 0));
      await touch2.moveBy(const Offset(15, 0));
      await tester.pumpAndSettle();

      // Get Current Visible Axis
      DateTime currVisibleMaximum = axisController.visibleMaximum as DateTime;
      DateTime currVisibleMinimum = axisController.visibleMinimum as DateTime;
      Duration zoom = currVisibleMaximum.difference(currVisibleMinimum);

      // Current Zoom should be less than 5 minutes
      expect(zoom, lessThan(const Duration(minutes: 5)));

      // Zoom Out
      await touch1.moveBy(const Offset(15, 0));
      await touch2.moveBy(const Offset(-15, 0));
      await tester.pumpAndSettle();

      // Get Current Visible Axis
      currVisibleMaximum = axisController.visibleMaximum as DateTime;
      currVisibleMinimum = axisController.visibleMinimum as DateTime;

      // Current Zoom Should be bigger once Zoomed Out
      expect(
          currVisibleMaximum.difference(currVisibleMinimum), greaterThan(zoom));

      // End Gestures
      await touch1.cancel();
      await touch2.cancel();
    });

    // Comment Test
    testWidgets("Graph Should be Able to be Commented",
        (WidgetTester tester) async {
      // Create a Test GraphWidget
      await tester.pumpWidget(ChangeNotifierProvider(
          create: (context) => AppStateProvider(),
          child: MaterialApp(
            home: Scaffold(
              body: GraphWidget(
                  number: 1,
                  data: dummyData,
                  paramName: 'lactate',
                  lineColor: Colors.red,
                  plotType: 's',
                  commentData: []),
            ),
          )));

      // Wait for the Chart to Properly Initiallize and Find the Coordinates of the Chart
      await tester.pumpAndSettle();
      final chart = find.byType(SfCartesianChart);
      final center = tester.getCenter(chart);

      // First Tap
      await tester.tapAt(center);
      await tester.pumpAndSettle();

      // Delay
      await tester.pump(const Duration(milliseconds: 100));

      // Second Tap
      await tester.tapAt(center);
      await tester.pumpAndSettle();

      // Check Comment Pop Up Box Appears
      expect(find.byType(CommentPopup), findsOneWidget);
    });
  });

  test("Testing DataHandler Class", () async {
    String dir = Directory.current.path;
    String filename = 'dummyDataCSV';
    List<String> channelNames = ["Glucose".toString(), "Lactate".toString()];
    int numChannels = 2;
    List<RustStreamSink<int>> streamSinks =
        List.filled(numChannels, RustStreamSink<int>());

    DataHandler dataHandler = DataHandler(
        streamSinks: streamSinks,
        numChannels: numChannels,
        dir: dir,
        filename: filename,
        isStatic: false,
        channelNames: channelNames);

    expect(dataHandler.error, false);

    for (int i = 0; i < 10; i++) {
      dataHandler.process(bytes: [0x00, 0x01, 0x00, 0x02]);
      sleep(Duration(milliseconds: 200));
    }

    int streamValue1 = await streamSinks[0].stream.first;

    expect(streamValue1, 10);

    File file = File("$dir/${filename}_1.csv");

    if (await file.exists()) {
      await file.delete();
    }
  });
}
