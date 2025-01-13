import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/utils/bluetooth_wrapper_interface.dart';
import 'package:baby_monitoring_app/widgets/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// This class contains all of the values that are contained within the app itself.
// This includes the list of channel names and the data handler (for communication
// with rust) 
class AppStateProvider with ChangeNotifier{
  List<String> _channelNames = []; // the current list of channel names
  DataHandler? _dataHandler; // the data handler
  BluetoothWrapper? _device; // the connected bluetooth device (if doing live plotting)
  List<List<ChartData>> _staticData = []; // Data if doing static plotting

  List<String> get channelNames => _channelNames; // getter for the channel names
  DataHandler? get dataHandler => _dataHandler; // getter for the data handler 
  BluetoothWrapper? get device => _device; // getter for the bluetooth device
  List<List<ChartData>> get staticData => _staticData; // getter for the static data

  // setter for the channel names
  void setChannelNames(List<String> channelNames) {
    _channelNames = channelNames;
    notifyListeners();
  }

  // setter for the data handler
  void setDataHandler(DataHandler dataHandler) {
    _dataHandler = dataHandler;
    notifyListeners();
  }

  // setter for the bluetooth device
  void setBluetoothDevice(BluetoothWrapper device) {
    _device = device;
    notifyListeners();
  }

  // setter for the static data
  void setStaticData(List<String> timeStrings, List<Uint16List> bitValues) {
    // Parse the string of times into DateTimes
    List<DateTime> times = timeStrings.map(
      (time) {
        return DateTime.parse(time);
      }
    ).toList();

    // the list of chart data values for a single channel (to be reused)
    List<ChartData> channelData = [];

    // Create a list of chart data values for each channel
    for (List<int> bitValList in bitValues) {
      // Parse the channel data
      channelData = bitValList.asMap().entries.map(
        (entry) {
          int index = entry.key;
          int bitVal = entry.value;

          return ChartData(times[index], bitVal);
        }
      ).toList();

      // Add the channel data to the static data list
      _staticData.add(channelData);
    }
    notifyListeners();
  }
}