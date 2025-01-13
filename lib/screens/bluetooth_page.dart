// bluetooth_page.dart
import 'package:flutter/material.dart';

class BluetoothDevicePage extends StatelessWidget {
  const BluetoothDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Device Selection')),
      body: const BluetoothDeviceList(),
    );
  }
}

class BluetoothDeviceList extends StatefulWidget {
  const BluetoothDeviceList({super.key});

  @override
  _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
}

class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
  List<String> availableDevices = ["Device A", "Device B", "Device C"];

  Future<void> scanForDevices() async {
    setState(() {
      availableDevices = ["Device X", "Device Y", "Device Z"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: availableDevices.length,
            itemBuilder: (context, index) {
              String deviceName = availableDevices[index];
              return ListTile(
                title: Text(deviceName),
                onTap: () => Navigator.pushNamed(context, '/livePlot'),
              );
            },
          ),
        ),
        ElevatedButton(onPressed: scanForDevices, child: const Text('Refresh Devices')),
      ],
    );
  }
}