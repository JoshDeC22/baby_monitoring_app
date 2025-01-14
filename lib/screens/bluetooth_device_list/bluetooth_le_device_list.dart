import 'dart:async';

import 'package:baby_monitoring_app/screens/first_screen.dart';
import 'package:baby_monitoring_app/screens/plot_pages/live_plot_page.dart';
import 'package:baby_monitoring_app/utils/state_management/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/bluetooth_wrappers/bluetooth_le.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

/* Reference 1 - taken from https://pub.dev/packages/flutter_blue_plus/example */
// This is the class that when instantiated scans for bluetooth low energy devices and lists any that are found.
// Since this is a StatefulWidget, any changes to the _results field in the state class will result in a UI update.
class BluetoothLEDevicePage extends StatefulWidget {
  const BluetoothLEDevicePage({super.key}); // Stateful widget constructor

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
      // Clear app state
      final appState = context.read<AppStateProvider>();
      appState.clearAppState();

      // Navigate back to the home page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false, // Clears the navigation stack
      );
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

                  // Navigate to the live plot page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LivePlotPage())
                  );
                },
              )
        ],
      )
    );
  }
}
/* end of reference */