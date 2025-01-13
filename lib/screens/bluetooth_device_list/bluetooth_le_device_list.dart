import 'dart:async';

import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/bluetooth_le.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

// This is the class that when instantiated scans for bluetooth low energy devices and lists any that are found.
// Since this is a StatefulWidget, any changes to the _results field in the state class will result in a UI update.
class BluetoothLEDevicePage extends StatefulWidget {
  const BluetoothLEDevicePage({Key? key}) : super(key: key); // Stateful widget constructor

  @override
  State<BluetoothLEDevicePage> createState() => _BluetoothLEDeviceState(); // Creates the state of this widget
}

// This is the class containing the state of the bluetooth low energy device page
class _BluetoothLEDeviceState extends State<BluetoothLEDevicePage> {
  List<ScanResult> _results = []; // list to hold all the results from each scan for bluetooth devices
  bool isScanning = false; // variable to store if the scanning has started

  // When the state is created these are the methods that are run
  @override
  void initState() {
    super.initState();
    _scan();
  }
  
  // This method scans for any bluetooth low energy devices and adds them to the _results field
  Future _scan() async {
    setState(() {
      _results.clear();
      isScanning = true;
    });

    try { 
      await FlutterBluePlus.startScan(); // start the scan
      FlutterBluePlus.scanResults.listen((result) { // listen for results and if found, update the _results field
        setState(() {
          _results = result;
        });
      }).onDone(() { // Restart the scan in case it stops for some reason
        if (isScanning) {
          _scan();
        }
      });
    }
    catch (e) {
      print(e); // Implelment error handling later
    }
  }

  // This is run once the bluetooth low energy device page is destroyed
  @override
  void dispose() {
    FlutterBluePlus.stopScan(); // stop scanning
    super.dispose();
  }

  // This is the method that builds the list of found devices.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: ListView(
        children: [
          if (_results.isEmpty)
            const Center(child: Text("No devices found."))
          else
            for (var result in _results)
              ListTile(
                title: Text(result.device.platformName.isEmpty ? "Unknown Device" : result.device.platformName),
                subtitle: Text(result.device.remoteId.toString()),
                onTap: () { // when one of the devices is tapped, wrap that device in the BluetoothLEWrapper and add it to the app state
                  BluetoothLEWrapper device = BluetoothLEWrapper(result.device, context);

                  // get the app state and add the device to it
                  final appState = Provider.of<AppStateProvider>(context);
                  appState.setBluetoothDevice(device);
                },
              )
        ],
      )
    );
  }
}