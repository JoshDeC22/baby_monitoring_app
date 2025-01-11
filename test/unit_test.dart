import 'package:baby_monitoring_app/widgets/data_model.dart';
import 'package:baby_monitoring_app/widgets/graph_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("One should be One", () {
    int expectedNumber = 1;
    expect(expectedNumber, 1);
  });

  group("WidgetTest", () {
    // Testing if Fullscreen Works
    testWidgets("Expanded Graph Test", (WidgetTester tester) async {
      // Dummy Data
      final List<ChartData> glucoseData = [
        ChartData(DateTime.now(), 4.5),
        ChartData(DateTime.now().add(const Duration(minutes: 1)), 5.0),
      ];

      // Create a Test GraphItem Widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GraphItem(
              number: 1,
              data: glucoseData,
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
  });
}
