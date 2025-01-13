import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnnotationProvider with ChangeNotifier {
  List<CartesianChartAnnotation> _annotationList = [];

  List<CartesianChartAnnotation> get annotationList => _annotationList;

  void addAnnotation(CartesianChartAnnotation annotation) {
    _annotationList.add(annotation);
    notifyListeners();
  }

  void clearAnnotations(CartesianChartAnnotation annotation) {
    _annotationList.clear();
    notifyListeners();
  }
}