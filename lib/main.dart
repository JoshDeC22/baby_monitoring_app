import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:baby_monitoring_app/src/rust/frb_generated.dart';
import 'package:provider/provider.dart';
//import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'screens/bluetooth_device_list/bluetooth_le_device_list.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(
    ChangeNotifierProvider(create: (context) => AppStateProvider(), child: const MyApp())
  );
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
