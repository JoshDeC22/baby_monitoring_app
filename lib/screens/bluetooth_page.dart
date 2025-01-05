import 'package:flutter/material.dart';

class BluetoothDevicePage extends StatelessWidget {
  const BluetoothDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Device Selection'),
      ),
      body: BluetoothDeviceList(),
    );
  }
}

class BluetoothDeviceList extends StatefulWidget {
  const BluetoothDeviceList({super.key});

  @override
  _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
}

class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
List<String> availableDevices = ["Device A", "Device B", "Device C"]; // Keep one declaration only

Future<void> scanForDevices() async {
  // Example of scanning (replace with your Bluetooth logic)
  setState(() {
    availableDevices = ["Device X", "Device Y", "Device Z"]; 
  });
}

  String? selectedDevice;

  Future<bool> connectToDevice(String deviceName) async {
    // Simulating a 2-second connection process
    await Future.delayed(const Duration(seconds: 2));
    return true; // Return true if connection is successful
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
                onTap: () async {
                  setState(() {
                    selectedDevice = deviceName;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Connecting to $deviceName...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  // Attempt to connect to the device
                  bool success = await connectToDevice(deviceName);

                  if (success) {
                    // Navigate to the Live Plot Page
                    Navigator.pushNamed(context, '/livePlot');
                  } else {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to connect to the device'),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Add refresh logic to discover new devices
            setState(() {
              availableDevices = ["Device X", "Device Y", "Device Z"];
            });
          },
          child: const Text("Refresh Devices"),
        ),
      ],
    );
  }
}
