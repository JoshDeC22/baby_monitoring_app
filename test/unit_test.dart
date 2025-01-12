import 'package:baby_monitoring_app/widgets/comment_popup.dart';
import 'package:baby_monitoring_app/widgets/data_model.dart';
import 'package:baby_monitoring_app/widgets/graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

main() {
  // Dummy Data
  DateTime dummyTime = DateTime.parse('2025-01-01 11:00:00Z'); // Year/Month/Day
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
                plotType: 's'
                ),
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
                plotType: 's'),
          ),
        ),
      );

      // Scroll Left
      await tester.drag(find.byType(SfCartesianChart), const Offset(-1000, 0));
      await tester.pumpAndSettle();

      // Check if the x-axis visible minimum and maximum values have changed after scrolling.
      final graphWidgetState =
          tester.state(find.byType(GraphWidget)) as GraphWidget;

      // final currentMin = graphWidgetState._xAxis.initialVisibleMinimum;
      // final currentMax = graphWidgetState._xAxis.initialVisibleMaximum;

      // expect(currentMin, 0);
      // expect(currentMax, 0);
    });

    /*
    // Zooming Test
    testWidgets("Graph Should be Able to Zoom in and out", (WidgetTester tester) async {
      // Create a Test GraphItem Widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GraphWidget(
              number: 1,
              data: dummyData,
              paramName: 'glucose',
              lineColor: Colors.green
            ),
          ),
        ),
      );

      // Wait for the Chart to Properly Initiallize and Find the Coordinates of the Chart
      await tester.pumpAndSettle();
      final chart = find.byType(SfCartesianChart);
      final center = tester.getCenter(chart);

      // Zoom In
      await tester.flingFrom(Offset(center.dx - 50, center.dy), Offset(center.dx - 200, center.dy), 500);
      await tester.flingFrom(Offset(center.dx + 50, center.dy), Offset(center.dx + 200, center.dy), 500);
  
      // Check Visible Axis
      //expect(widget, findsNothing);

      // Zoom Out
      await tester.flingFrom(Offset(center.dx - 200, center.dy), Offset(center.dx - 50, center.dy), 500);
      await tester.flingFrom(Offset(center.dx + 200, center.dy), Offset(center.dx + 50, center.dy), 500);

      // Check Visible Axis
      //expect(widget, findsNothing);
    });
    */

    // Comment Test
    testWidgets("Graph Should be Able to be Commented",
        (WidgetTester tester) async {
      // Create a Test GraphItem Widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GraphWidget(
                number: 1,
                data: dummyData,
                paramName: 'lactate',
                lineColor: Colors.red,
                plotType: 's'),
          ),
        ),
      );

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

      // Check Comment Pop Up
      expect(find.byType(CommentPopup), findsOneWidget);

      // Type Something
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Coordinates of the Save Button
      final saveButton = find.text('Save');
      final saveCenter = tester.getCenter(saveButton);

      // Press Save
      await tester.enterText(textField, 'Dummy Comment');
      await tester.tapAt(saveCenter);
      await tester.pumpAndSettle();

      // Check Created Comment
      expect(find.text('Dummy Comment'), findsOneWidget);
    });
  });
}
