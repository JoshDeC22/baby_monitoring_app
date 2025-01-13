import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// This class is the comment popup that is used to add the text for annotations
class CommentPopup extends StatefulWidget {
  final DateTime time; // the x position of the annotation
  final int bitVal; // the y position of the annotation
  // The current list of annotations wrapped with a ValueNotifier to update all listeners
  // if an annotation is added
  final ValueNotifier<List<CartesianChartAnnotation>> annotations;

  // The constructor for the CommentPopup
  const CommentPopup({
    super.key,
    required this.time,
    required this.bitVal,
    required this.annotations,
  });

  // Since this is a stateful widget, the widget state is initialized here
  @override
  CommentPopupState createState() => CommentPopupState();
}

// This class manages the state of the CommentPopup class
class CommentPopupState extends State<CommentPopup> {
  final TextEditingController _controller = TextEditingController(); // controller so that the user can enter text

  // When the popup is closed it also removes the controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // This function builds the popup
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Shape of the popup
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create Comment for the time ${widget.time.toString()}"), // title of the popup
            // the text field where the user enters the annotation
            TextField(
              controller: _controller, // controller to enter text
              // the decoration that displays before any text is entered
              decoration: const InputDecoration(
                labelText: "Enter annotation...",
                border: OutlineInputBorder(),
              ),
            ),
            // This row contains the save and cancel buttons for the annotations
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Create the save button which adds a new annotation to the annotations list
                ElevatedButton(
                  onPressed: () {
                    String comment = _controller.text; // get the text within the text field
                    if (comment.isNotEmpty) {
                      // Create the chart annotation
                      final annotation = CartesianChartAnnotation(
                        // Create the outline of the annotation
                        widget: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // Set the text inside the annotation to the text within the text field
                          child: Text(
                            comment,
                          ),
                        ),
                        // set the coordinate of the annotation
                        coordinateUnit: CoordinateUnit.point,
                        x: widget.time,
                        y: widget.bitVal,
                      );
                      // add the annotation to the annotations list
                      widget.annotations.value = [...widget.annotations.value, annotation];
                      // Get the app state and data handler
                      final appState = Provider.of<AppStateProvider>(context);
                      DataHandler dataHandler = appState.dataHandler!;
                      dataHandler.saveCommentsCsv(comment: comment, timestamp: widget.time);
                      // close the popup
                      Navigator.pop(context);
                    }
                  }, 
                  child: const Text("Save"), // set the text for the save button
                ),
                // create the Cancel button
                ElevatedButton(
                  onPressed: () {
                    // close the popup
                    Navigator.pop(context);
                  }, 
                  child: const Text("Cancel"), // set the text for the cancel button
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}