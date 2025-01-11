import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CommentPopup extends StatefulWidget {
  final DateTime time;
  final int bitVal;
  final ValueNotifier<List<CartesianChartAnnotation>> annotations;

  const CommentPopup({
    super.key,
    required this.time,
    required this.bitVal,
    required this.annotations,
  });

  @override
  CommentPopupState createState() => CommentPopupState();
}

class CommentPopupState extends State<CommentPopup> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create Comment for the time ${widget.time.toString()}"),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter comment...",
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String comment = _controller.text;
                    if (comment.isNotEmpty) {
                      final annotation = CartesianChartAnnotation( // Change parameters
                        widget: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text( // Change parameters
                            comment,
                          ),
                        ),
                        coordinateUnit: CoordinateUnit.point,
                        x: widget.time,
                        y: widget.bitVal,
                      );
                      widget.annotations.value = [...widget.annotations.value, annotation];
                      Navigator.pop(context);
                    }
                  }, 
                  child: const Text("Save"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: const Text("Cancel"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Placeholder function to be replaced by rust function
void _saveCommentData(String comment, DateTime time) {

}