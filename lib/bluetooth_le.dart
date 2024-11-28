import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothLEWrapper {
  // This class is the wrapper class for interacting with a bluetooth low energy device.

  final BluetoothCharacteristic _characteristic; // This is essentially the data that you are looking for

  // Constructor initializes the correct characteristic and sets the characteristic to automatically update
  // when data is received
  BluetoothLEWrapper(this._characteristic) {
    _getNotifications();
  }

  // This function ensures that whenever data is streamed to the device, the code updates.
  Future<void> _getNotifications() async {
    await _characteristic.setNotifyValue(true);
  }

  // This function calls the rust code everytime data is sent to the device.
  Future<void> readData() async {
    try {
      _characteristic.onValueReceived.listen((data) {
        // Process data in rust here
      });
    }
    catch (e) {
      print(e);
    }
  }
}