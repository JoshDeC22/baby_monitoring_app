import 'package:baby_monitoring_app/widgets/data_model.dart';
import 'package:baby_monitoring_app/widgets/graph_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("One should be One", () {
    int expectedNumber = 1;
    expect(expectedNumber, 1);
  });

  // Dummy Data
  final List<ChartData> dummyData = [
    ChartData(DateTime.now(), 4),
    ChartData(DateTime.now().add(const Duration(minutes: 1)), 5),
  ];

  group("WidgetTest", () {
    // Fullscreen Test
    testWidgets("Graph Should be Able to Fullscreen",
        (WidgetTester tester) async {
      // Create a Test GraphItem Widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GraphItem(
              number: 1,
              data: dummyData,
              plotType: 'glucose',
            ),
          ),
        ),
      );

      // Tap the Fullscreen Icon
      await tester.tap(find.byIcon(Icons.fullscreen));
      await tester.pumpAndSettle();

      // Checks if Expanded Graph Appears
      expect(find.byType(ExpandedGraphPage), findsOneWidget);
    });

    // Scrolling Test
    testWidgets("Graph Should be Able to Fullscreen",
        (WidgetTester tester) async {
      // Create a Test GraphItem Widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GraphItem(
              number: 2,
              data: dummyData,
              plotType: 'lactate',
            ),
          ),
        ),
      );

      // Scroll Left
      await tester.drag(find.byType(GraphItem), const Offset(-300, 0));
      await tester.pump();

      // Checks if Scrolled
      //expect();
    });
  });
}
