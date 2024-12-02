import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class BluetoothClassicListPage extends StatefulWidget {
  const BluetoothClassicListPage({Key? key}) : super(key: key);

  @override
  State<BluetoothClassicListPage> createState() => _BluetoothClassicListState();
}

class _BluetoothClassicListState extends State<BluetoothClassicListPage> {
  final _plugin = FlutterBlueClassic();

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterSubscription;

  final Set<BluetoothDevice> _results = {};
  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  int? _connectingIndex;
  StreamSubscription? _scanningSubscription;

  @override
  void initState() {
    super.initState();
    initWidgetState();
  }

  Future<void> initWidgetState() async {
    BluetoothAdapterState adapterState = _adapterState;

    try {
      adapterState = await _plugin.adapterStateNow;
      _adapterSubscription = _plugin.adapterState.listen((state) {
        if (mounted) {
          setState(() => _adapterState = state);
        }
      });
      _scanSubscription = _plugin.scanResults.listen((device) {
        if (mounted) {
          setState(() => _results.add(device));
        }
      });
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

  @override
  void dispose() {
    _adapterSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> results = _results.toList();

    return ListView(
      children: [
        if (results.isEmpty)
          const Center(child: Text('No devices found.'))
        else 
          for (var result in results)
            ListTile(
              title: Text(result.name ?? "Unknown Device"),
              subtitle: Text("(${result.address})")
            ),
            const Padding(
              padding: EdgeInsets.only(top: 23),
              child: Divider(),
            )
      ],
    );
  }
}