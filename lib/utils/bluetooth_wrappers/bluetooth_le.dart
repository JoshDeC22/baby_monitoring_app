import 'dart:async';

import 'package:baby_monitoring_app/screens/first_screen.dart';
import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/utils/state_management/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/bluetooth_wrappers/bluetooth_wrapper_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

// This class is the wrapper class for interacting with a bluetooth low energy device.
class BluetoothLEWrapper implements BluetoothWrapper {
  final BluetoothDevice _device; // This is essentially the data that you are looking for
  late DataHandler _dataHandler; // The data handler for communication with rust
  late BluetoothCharacteristic _characteristic;

  // Constructor initializes the correct characteristic and sets the characteristic to automatically update
  // when data is received
  BluetoothLEWrapper(this._device, BuildContext context) {
    // get the data handler from the app state
    final appState = Provider.of<AppStateProvider>(context);
    _dataHandler = appState.dataHandler!;

    _connect(context);
  }

  // This function ensures that whenever data is streamed to the device, the code updates.
  Future<void> _connect(BuildContext context) async {
    await _device.connect();
    List<BluetoothService> services = await _device.discoverServices();
    _characteristic = services[0].characteristics[0];
    await _characteristic.setNotifyValue(true);
    await _readData(context);
  }

  // This function calls the rust code everytime data is sent to the device.
  Future<void> _readData(BuildContext context) async {
    try {
      _characteristic.onValueReceived.listen((data) {
        _dataHandler.process(bytes: data);
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

  // This function closes the connection when live plotting is finished
  @override
  void disconnect() {
    _device.disconnect();
  }
}