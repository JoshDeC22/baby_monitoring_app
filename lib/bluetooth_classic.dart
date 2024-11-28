import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class BtClassicWrapper {
  // This is the wrapper class for interacting with a bluetooth classic device

  final BluetoothDevice _device; // The device that has been connected
  final FlutterBlueClassic _plugin = FlutterBlueClassic(); // The flutter_blue_classic main plugin
  BluetoothConnection? _conn; // The connection established to the device

  // Constructor that intializes the device object and gets the connection
  BtClassicWrapper(this._device) {
    connect(); 
  }

  // Establishes the connection to the bluetooth device
  Future<void> connect() async {
    try {
      _conn = await _plugin.connect(_device.address);
    } catch (e) {
      print(e); // Proper error handling to be implemented later
    }
  }

  // Reads the data being sent from the bluetooth device. This function will be called everytime data is sent from
  // the sensor
  Future<void> readData() async {
    try {
      _conn!.input!.listen((data) {
        // Call rust function to handle the data here
      });
    }
    catch (e) {
      print(e); // Proper error handling to be implemented later
    }
  }
}