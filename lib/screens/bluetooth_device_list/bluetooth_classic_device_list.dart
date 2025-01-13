import 'dart:async';

import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:baby_monitoring_app/utils/bluetooth_classic.dart';
import 'package:baby_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:provider/provider.dart';

// This class is essentially the list of bluetooth classic devices that the android tablet can detect
class BluetoothClassicListPage extends StatefulWidget {
  const BluetoothClassicListPage({Key? key}) : super(key: key);

  // since this is a stateful widget, the state is created here
  @override
  State<BluetoothClassicListPage> createState() => _BluetoothClassicListState();
}

// This class manages the state for BluetoothClassicListPage
class _BluetoothClassicListState extends State<BluetoothClassicListPage> {
  final _plugin = FlutterBlueClassic(); // the plugin to interact with android bluetooth
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown; // the adapter state
  StreamSubscription? _adapterSubscription; // the stream subscription for the adapter
  final Set<BluetoothDevice> _results = {}; // the results from the scan for devices
  StreamSubscription? _scanSubscription; // the stream subscription for the scan results
  bool _isScanning = false; // tells whether the device is scanning or not
  int? _connectingIndex; // gets the index of the device that is being connected
  StreamSubscription? _scanningSubscription; // the stream subscription for the scan

  // THis function initializes the state of the page
  @override
  void initState() {
    super.initState();
    initWidgetState();
  }

  Future<void> initWidgetState() async {
    BluetoothAdapterState adapterState = _adapterState; // get the current adapterState

    try {
      // Get the adapter state and adapter subscription
      adapterState = await _plugin.adapterStateNow;
      _adapterSubscription = _plugin.adapterState.listen((state) {
        if (mounted) {
          setState(() => _adapterState = state);
        }
      });
      // Scan for all the devices
      _scanSubscription = _plugin.scanResults.listen((device) {
        if (mounted) {
          setState(() => _results.add(device));
        }
      });
      // Check whether the scan is ongoing or not
      _scanningSubscription = _plugin.isScanning.listen((scanning) {
        if (mounted) {
          setState(() => _isScanning = scanning);
        }
      });
    }
    catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _adapterState = adapterState;
    });
  }

  // This function cancels all the subscriptions when the page is closed
  @override
  void dispose() {
    _adapterSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningSubscription?.cancel();
    super.dispose();
  }

  // This function builds the page
  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> results = _results.toList(); // results of the scan

    return ListView(
      children: [
        if (results.isEmpty)
          const Center(child: Text('No devices found.')) // Display "No devices found." if the scan yields no results
        else 
          for (var result in results)
          // if the scan has results, list them
            ListTile(
              title: Text(result.name ?? "Unknown Device"),
              subtitle: Text("(${result.address})"),
              onTap: () { // when a device is tapped, wrap the device with the BtClassicWrapper and add it to the app state
                BtClassicWrapper device = BtClassicWrapper(result, context); // Wrap the device

                // Get the app state and add the device
                final appState = Provider.of<AppStateProvider>(context);
                appState.setBluetoothDevice(device);
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 23),
              child: Divider(),
            )
      ],
    );
  }
}