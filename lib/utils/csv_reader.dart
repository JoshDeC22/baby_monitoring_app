import 'dart:convert';
import 'package:flutter/services.dart';
import '../blood_data.dart'; // Import your BloodData model

Future<List<BloodData>> loadGlucoseData(String assetPath) async {
  final csvString = await rootBundle.loadString(assetPath);
  final lines = const LineSplitter().convert(csvString);
  final data = <BloodData>[];

  for (var i = 1; i < lines.length; i++) { // Skip header row
    final row = lines[i].split(',');
    final time = DateTime.parse(row[0]); // Parse the timestamp
    final value = double.parse(row[1]); // Parse the glucose value
    data.add(BloodData(time, value));
  }

  return data;
}
