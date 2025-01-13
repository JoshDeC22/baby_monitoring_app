import 'package:baby_monitoring_app/screens/static_plot_page.dart';
import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/colors.dart';
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
  List<Uint16List> _bitValues = []; // List of data values for each channel (if doing static plotting)
  List<List<String>> _commentData = []; // List of the comments associated with this data
  List<String> _channelNames = []; // List of the channel names

  // This function builds all the widgets within the home screen
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.darkBlue, // Set the entire background to darkBlue
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center content vertically
            children: [
              // Add the logo image
              Image.asset(
                'assets/AppLogo.png', // Update to the correct path of your image
                width: 500.0,
                height: 150.0,
              ),
              const SizedBox(height: 20.0),
        // Create the button to connect to a bluetooth classic device
        Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: SizedBox(
                  width: 400, 
                  child: ElevatedButton(
          onPressed: () {
            // Show the popup to add channel names
            showDialog(
              context: context, 
              builder: (BuildContext context) {
                return ChannelPopup(bluetoothClassic: true); // true because connecting to a bluetooth classic device
              },
            );
           },
            style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.paleYellow,
                   foregroundColor: Colors.black,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: AppColors.yellow, width: 1.0),
            ),
          ), 
          child: Text("Connect to Bluetooth Classic Device")
        ),  
         ),
              ),
        // Create the button to connect to a bluetooth LE device
        Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: 400, 
                  child: ElevatedButton(
          onPressed: () {
            // show the popup to add channel names
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ChannelPopup(bluetoothClassic: false); // false because connecting to a bluetooth LE device
              },
            );
          }, 
          style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.paleYellow,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColors.yellow, width: 1.0),
                      ),
                    ),
                    child: const Text("Connect to Bluetooth LE Device"),
                  ),
                ),
              ),
        // Create the button to open a file
         Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: SizedBox(
                  width: 400, 
                  child: ElevatedButton(
          onPressed: () {
            // Get the app state
            final appState = Provider.of<AppStateProvider>(context);

            // initialize the variable to hold the file name
            String filename = '';

            // Get the user to select a file to open
            FilePicker.platform.pickFiles().then(
              (result) {
                if (result != null) {
                  filename = result.files.single.name;
                } else {
                  // if an error occurs clear the app state and don't go further
                  appState.clearAppState();
                  return;
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
                    final (timeStrings, bitValues, commentData, channelNames) = result!;
                    setState(() {
                      _timeStrings = timeStrings;
                      _bitValues = bitValues;
                      _commentData = commentData;
                      _channelNames = channelNames;
                    });
                  }
                );

                // Create the data handler and add it to the app state
                String dir = p.dirname(filename); // get the directory of the csv file
                String name = p.basename(filename); // get the base file name of the csv file

                DataHandler dataHandler = DataHandler(streamSinks: [], numChannels: 0, dir: dir, filename: name, isStatic: true, channelNames: null);
                appState.setDataHandler(dataHandler);

                // Add the data to the app state
                appState.setStaticData(_timeStrings, _bitValues);

                // Add the comments to the app state
                appState.setStaticCommentData(_commentData);

                // Add the channel names to the app state
                appState.setChannelNames(_channelNames);

                // Navigate to the static plot page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StaticPlotPage())
                );
              } catch (error) {
                // if an error occurs clear the app state and don't go further
                appState.clearAppState();
                return;
              }
            } else {
              // if an error occurs clear the app state and don't go further
              appState.clearAppState();
              return;
            }
          }, 
          style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.palePink,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColors.darkPink, width: 1.0),
                      ),
                    ),
          child: Text("Open File")
        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}