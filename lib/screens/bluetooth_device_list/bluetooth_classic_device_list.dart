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

    return Scaffold(
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(90.0), // Increase AppBar height
  child: Container(
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: AppBar(
      leadingWidth: 250.0, // Explicitly set the width of the leading area
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/AppLogo.png', // Path to your image
          fit: BoxFit.contain,
        ),
      ),
      title: const Text(
        'Bluetooth Classic Device Selection',
        style: TextStyle(
          color: Colors.white,
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.darkBlue,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0), // Add padding to move icon away from border
          child: IconButton(
            icon: const Icon(
              Icons.home,
              size: 40.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/home'); // Navigate to the HomeScreen
            },
          ),
        ),
      ],
    ),
  ),
),


     body: Container(
        color: AppColors.backgroundGrey, // Set the background color
        child: results.isEmpty
              ? const Center(
                child: Text('No devices found', // Display "No devices found." if the scan yields no results
                style: TextStyle(
                    color: AppColors.darkRed,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.darkRed,
                  ),
                ),
              )
            : ListView(
                children: [
                  for (var result in results)
                    ListTile(
                      title: Text(result.name ?? "Unknown Device"),
                      subtitle: Text("(${result.address})"),
                      onTap: () {
                        BtClassicWrapper device = BtClassicWrapper(result, context);
                        final appState = Provider.of<AppStateProvider>(context);
                        appState.setBluetoothDevice(device);
                      },
                    ),
                  const Padding(
                    padding: EdgeInsets.only(top: 23),
                    child: Divider(),
                  ),
                ],
              ),
      ),
    );
  }
}