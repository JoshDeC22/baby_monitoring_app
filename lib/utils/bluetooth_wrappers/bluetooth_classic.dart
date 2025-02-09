import 'package:baby_monitoring_app/screens/first_screen.dart';
import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/utils/state_management/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/bluetooth_wrappers/bluetooth_wrapper_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:provider/provider.dart';

// This is the wrapper class for interacting with a bluetooth classic device
class BtClassicWrapper implements BluetoothWrapper {
  final BluetoothDevice _device; // The device that has been connected
  final FlutterBlueClassic _plugin = FlutterBlueClassic(); // The flutter_blue_classic main plugin
  BluetoothConnection? _conn; // The connection established to the device
  late DataHandler _dataHandler; // The data handler for communication with rust

  // Constructor that intializes the device object and gets the connection
  BtClassicWrapper(this._device, BuildContext context) {
    // get the data handler from the app state
    final appState = Provider.of<AppStateProvider>(context);
    _dataHandler = appState.dataHandler!;

    // Connect to the bluetooth device
    _connect(context); 
  }

  // Establishes the connection to the bluetooth device
  Future<void> _connect(BuildContext context) async {
    try {
      _conn = await _plugin.connect(_device.address);
      if (_conn != null) {
        await _readData(context);
      }
    } catch (e) {
      // clear the app state and navigate back to the home screen
      final appState = context.read<AppStateProvider>();
      appState.clearAppState();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // Reads the data being sent from the bluetooth device. This function will be called everytime data is sent from
  // the sensor
  Future<void> _readData(BuildContext context) async {
    try {
      _conn!.input!.listen((data) {
         // Sends the data (bytes) to the DataHandler to be processed into u16.
        _dataHandler.process(bytes: data); // DataHandler will also save the values into a CSV file
      });
    }
    catch (e) {
      // clear the app state and navigate back to the home screen
      final appState = context.read<AppStateProvider>();
      appState.clearAppState();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // This function disconnects the device when done real time plotting
  @override
  void disconnect() {
    if (_conn != null) {
      _conn!.close();
    }
  }
}