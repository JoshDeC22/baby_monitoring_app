import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:baby_monitoring_app/widgets/channel_popup.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

// This class represents the first screen that pops up when the user opens the app
// here they are able to specify whether they want to open a file, connect to a bluetooth
// classic device or connect to a bluetooth LE device.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Since this is a stateful widget, the state is initialized here
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<String> _timeStrings = []; // List of static times (if doing static plotting)
  List<Uint16List> _bitValues = []; // List of data values for each channle (if doing static plotting)

  // This function builds all the widgets within the home screen
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Create the button to connect to a bluetooth classic device
        ElevatedButton(
          onPressed: () {
            // Show the popup to add channel names
            showDialog(
              context: context, 
              builder: (BuildContext context) {
                return ChannelPopup(bluetoothClassic: true); // true because connecting to a bluetooth classic device
              }
            );
          }, 
          child: Text("Connect to Bluetooth Classic Device")
        ),  
        // Create the button to connect to a bluetooth LE device
        ElevatedButton(
          onPressed: () {
            // show the popup to add channel names
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ChannelPopup(bluetoothClassic: false); // false because connecting to a bluetooth LE device
              },
            );
          }, 
          child: Text("Connect to Bluetooth LE Device")
        ),  
        // Create the button to open a file
        ElevatedButton(
          onPressed: () {
            // initialize the variable to hold the file name
            String filename = '';

            // Get the user to select a file to open
            FilePicker.platform.pickFiles().then(
              (result) {
                if (result != null) {
                  filename = result.files.single.name;
                } else {
                  // TODO: error handle
                }
              }
            );

            // get the file extension
            String fileExtension = p.extension(filename);

            // check to ensure that the user is opening a csv file
            if (fileExtension == '.csv') {
              // read the data from the csv file using rust
              try {
                // get the data from rust
                DataHandler.readDataCsv(fileDirectory: filename).then(
                  (result) {
                    // Get the data and change the widget state
                    final (timeStrings, bitValues) = result!;
                    setState(() {
                      _timeStrings = timeStrings;
                      _bitValues = bitValues;
                    });
                  }
                );

                // Add the data to the app state
                final appState = Provider.of<AppStateProvider>(context);
                appState.setStaticData(_timeStrings, _bitValues);

                // TODO: navigate to static plot page
              } catch (error) {
                // TODO: error handle
              }
            } else {
              // TODO: error handle
            }
          }, 
          child: Text("Open File")
        ),  
      ],
    );
  }
}