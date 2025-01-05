import 'package:flutter/material.dart';
import 'package:baby_monitoring_app/src/rust/frb_generated.dart';
import 'package:baby_monitoring_app/screens/bluetooth_page.dart';
import 'live_plot_page.dart'; 

Future<void> main() async {
  try {
    await RustLib.init();
  } catch (e) {
    print('Failed to initialise Rust library: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Health Monitoring App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BluetoothDevicePage(),
        '/livePlot': (context) => const LivePlotPage(), 
      },
    );
  }
}
