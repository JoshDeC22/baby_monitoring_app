import 'package:baby_monitoring_app/screens/first_screen.dart';
import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/screens/bluetooth_device_list/bluetooth_classic_device_list.dart';
import 'package:baby_monitoring_app/screens/bluetooth_device_list/bluetooth_le_device_list.dart';
import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:provider/provider.dart';

// This class is the popup that allows the user to specify the number of channels
// and the channel names that they want.
class ChannelPopup extends StatefulWidget {
  final bool
      bluetoothClassic; //if true then the user wants to connect to a bluetooth classic device and BLE if false

  // Constructor for the class
  const ChannelPopup({
    super.key,
    required this.bluetoothClassic,
  });

  // Since this is a stateful widget, the widget state is initialized here
  @override
  ChannelPopupState createState() => ChannelPopupState();
}

// This class manages the state of ChannelPopup
class ChannelPopupState extends State<ChannelPopup> {
  List<String> _channelNames = [
    "Glucose",
    "Lactate"
  ]; // the list of channels (defaults to just glucose and lactate)
  bool _addingName = false; // tracks whether a name is being added or not
  final TextEditingController _controller =
      TextEditingController(); // Controller to add names to the list
  String? _dir;
  String? _filename;

  // When the popup is closed, it also removes the controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // This function prompts the user to select a directory and set a filename for the csv files where the data
  // from the bluetooth devices will be stored
  void _getPath() {
    // get the directory and filename
    _getDir();
    _getFilename();

    // check to make sure user has selected a directory/filename
    if (_dir == null || _filename == null) {
      // clear the app state and navigate back to the home screen
      final appState = context.read<AppStateProvider>();
      appState.clearAppState();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }

    final appState = context.read<AppStateProvider>();

    // get the number of channels and create a list of stream sinks for each
    int numChannels = _channelNames.length;
    List<RustStreamSink<int>> streamSinks =
        List.filled(numChannels, RustStreamSink<int>());

    // Create the data handler object and add it to the app state
    DataHandler dataHandler = DataHandler(
        streamSinks: streamSinks,
        numChannels: numChannels,
        dir: _dir!,
        filename: _filename!,
        isStatic: false,
        channelNames: _channelNames);
    appState.setDataHandler(dataHandler);
    appState.setDataStreams(streamSinks);

    // Navigate to either the bluetooth classic or LE device list
    if (widget.bluetoothClassic) {
      // Navigate to bluetooth classic device list
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BluetoothClassicListPage()),
      );
    } else {
      // Navigate to bluetooth LE device list
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BluetoothLEDevicePage()));
    }
  }

  // This function prompts the user to select a directory to store the csv files where the data from the
  // bluetooth devices will be saved
  void _getDir() {
    // get the user to select a directory
    FilePicker.platform.getDirectoryPath().then((dir) {
      if (dir != null) {
        setState(() {
          _dir = dir;
        });
      }
    });
  }

  // This function prompts the user to type a file name for the csv files where the data from the
  // bluetooth devices will be saved
  void _getFilename() {
    // Get the user to enter a filename
    TextEditingController controller = TextEditingController();
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          // Use an AlertDialog
          return AlertDialog(
            // Create a text field for the user to enter the filename
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Enter filename...",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              // Create the buttons to save the filename or cancel
              // Create the button to cancel
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close the popup
                },
                child: Text("Cancel"),
              ),
              // Create the button to save the file name
              ElevatedButton(
                  onPressed: () {
                    // update the filename if the user has entered text
                    if (controller.text.isNotEmpty) {
                      setState(() {
                        _filename = "${controller.text}.csv";
                      });
                    }

                    Navigator.of(context).pop(); // close the popup
                  },
                  child: Text("Save")),
            ],
          );
        });
  }

  // This function builds the popup/dialog
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), // shape of the popup
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 300,
                // Make a ListView for all the channel names
                child: ListView.builder(
                  itemCount: _channelNames.length +
                      (_addingName
                          ? 1
                          : 0), // number of items in the ListView (add 1 if adding a channel name)
                  // build the ListView
                  itemBuilder: (context, index) {
                    // If adding a channel name, make a textbox appear at the bottom of the list
                    if (_addingName && index == _channelNames.length) {
                      return TextField(
                        controller: _controller, // controller for the text field
                        decoration: InputDecoration(
                          labelText: "Enter channel name...",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            // Create the button to submit the channel name to be added
                            onPressed: () {
                              // if the controller is not empty, add the channel name to the channel name list and to the ListView
                              if (_controller.text.isNotEmpty) {
                                setState(() {
                                  _channelNames.add(_controller
                                      .text); // add the new name to the channel name list
                                  _addingName = false; // No longer adding a name
                                  _controller
                                      .clear(); // clear the controller for reuse
                                });
                              }
                            },
                            icon: Icon(Icons
                                .check), // set the icon of the button to a check mark
                          ),
                        ),
                      );
                    }
                    return ListTile(title: Text(_channelNames[index]));
                  },
                ),
              ),
              SizedBox(height: 10),
              // Create the button to add a channel name and the button to close the popup.
              Row(
                children: [
                  // Create the button to add a channel name
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _addingName =
                            true; // set the adding name parameter to true and rebuild the widget
                      });
                    },
                    child: Text('Add Channel'),
                  ),
                  // Create the button to close the popup
                  ElevatedButton(
                    onPressed: () {
                      // update the app state and add the new channel list
                      final appState = context.read<AppStateProvider>();
                      appState.setChannelNames(_channelNames);

                      // show the popup to get the directory and set the filename for csv files where the
                      // data from the bluetooth device will be stored and then create the data handler
                      _getPath();

                      // close the popup
                      Navigator.pop(context);
                    },
                    child: Text("Close"),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
