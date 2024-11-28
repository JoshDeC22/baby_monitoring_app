import 'package:flutter/material.dart';
import 'package:baby_monitoring_app/src/rust/frb_generated.dart';

import 'src/screens/bluetooth_device_list/bluetooth_le_device_list.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothLEDevicePage()
    );
  }
}
