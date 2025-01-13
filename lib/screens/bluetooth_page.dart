// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:baby_monitoring_app/utils/colors.dart'; // Ensure colors.dart is correctly imported

class BluetoothDevicePage extends StatelessWidget {
  const BluetoothDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), //AppBar height
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5), 
                spreadRadius: 1, 
                blurRadius: 10, 
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            title: const Text(
              'Bluetooth Device Selection',
              style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.darkBlue, 
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 50), 
                onPressed: () => _showPopupMenu(context),
              ),
            ],
          ),
        ),
      ),
      body: const BluetoothDeviceList(),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(200.0, 80.0, 0.0, 0.0), //IconButton position
      items: [
        PopupMenuItem<String>(
          value: 'past_recordings',
          onTap: () {
            Navigator.pushNamed(context, '/pastRecordings'); // Navigation to past recordings
          },
          child: 
          const Text('Go to past recordings',
          textAlign: TextAlign.center, 
          style: TextStyle(fontSize: 18), 
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}

class BluetoothDeviceList extends StatefulWidget {
  const BluetoothDeviceList({super.key});

  @override
  _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
}

class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
  List<String> availableDevices = ['Device A', 'Device B', 'Device C'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20), 
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                'Select a device for connection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            for (String deviceName in availableDevices)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: 350,  // Width for buttons
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.paleYellow,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColors.yellow, width: 1.0),
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/livePlot'),
                    child: Text(deviceName),
                  ),
                ),
              ),
            const SizedBox(height: 40),  // Space before the refresh button
            ElevatedButton(
              onPressed: () {},  // Placeholder function for refresh
              child: const Text('Refresh Devices'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}