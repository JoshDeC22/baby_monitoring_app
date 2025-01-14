// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:baby_monitoring_app/utils/colors.dart'; // Ensure colors.dart is correctly imported
import 'package:baby_monitoring_app/screens/first_screen.dart'; // Import for navigation

class BluetoothDevicePage extends StatelessWidget {
  const BluetoothDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // AppBar height
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
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
            leading: IconButton( // Added back button
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Navigates back to the previous page
              },
            ),
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
      position: const RelativeRect.fromLTRB(200.0, 80.0, 0.0, 0.0),
      items: [
        PopupMenuItem<String>(
          value: 'past_recordings',
          onTap: () {
            Navigator.pushNamed(context, '/pastRecordings'); 
          },
          child: const Text(
            'Go to past recordings',
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
                  width: 350, 
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
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},  
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Refresh Devices'),
            ),
          ],
        ),
      ),
    );
  }
}
