import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/bluetooth_wrapper_interface.dart';
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

    _connect(); 
  }

  // Establishes the connection to the bluetooth device
  Future<void> _connect() async {
    try {
      _conn = await _plugin.connect(_device.address);
      if (_conn != null) {
        await _readData();
      }
    } catch (e) {
      print(e); // Proper error handling to be implemented later
    }
  }

  // Reads the data being sent from the bluetooth device. This function will be called everytime data is sent from
  // the sensor
  Future<void> _readData() async {
    try {
      _conn!.input!.listen((data) {
        _dataHandler.process(bytes: data);
      });
    }
    catch (e) {
      print(e); // Proper error handling to be implemented later
    }
  }
}