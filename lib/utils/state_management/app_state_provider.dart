import 'package:baby_monitoring_app/src/rust/api/data_handler.dart';
import 'package:baby_monitoring_app/utils/bluetooth_wrappers/bluetooth_wrapper_interface.dart';
import 'package:baby_monitoring_app/utils/data_wrappers/comment_data.dart';
import 'package:baby_monitoring_app/utils/data_wrappers/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// This class contains all of the values that are contained within the app itself.
// This includes the list of channel names and the data handler (for communication
// with rust). This is essentially the state manager of the entire app. All widgets
// can access the data contained within the AppStateProvider.
class AppStateProvider with ChangeNotifier{
  List<String> _channelNames = []; // the current list of channel names
  DataHandler? _dataHandler; // the data handler
  List<RustStreamSink<int>> _dataStreams = []; // the data streams for live plotting
  BluetoothWrapper? _device; // the connected bluetooth device (if doing live plotting)
  List<List<ChartData>> _staticData = []; // Data if doing static plotting
  List<CommentData> _staticCommentData = []; // Static comments loaded from a csv file

  List<String> get channelNames => _channelNames; // getter for the channel names
  DataHandler? get dataHandler => _dataHandler; // getter for the data handler 
  BluetoothWrapper? get device => _device; // getter for the bluetooth device
  List<List<ChartData>> get staticData => _staticData; // getter for the static data
  List<RustStreamSink<int>>? get dataStreams => _dataStreams; // getter for the data streams if live plotting
  List<CommentData> get staticCommentData => _staticCommentData; // getter for the static comment data

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

  // setter for the data streams
  void setDataStreams(List<RustStreamSink<int>> dataStreams) {
    _dataStreams = dataStreams;
    notifyListeners();
  }

  // setter for the static comment data
  void setStaticCommentData(List<List<String>> allComments) {
    // separate the comments based on their timestamp and comment
    List<String> timeStrings = allComments[0];
    List<String> comments = allComments[1];

    // parse the time strings into DateTime objects
    List<DateTime> times = timeStrings.map(
      (time) {
        return DateTime.parse(time);
      }
    ).toList();

    // Convert the comments to CommentData objects and add them to the _staticCommentData list
    for (int i = 0; i < comments.length; i++) {
      final comment = comments[i];
      final time = times[i];
      _staticCommentData.add(CommentData(time, comment));
    }
    notifyListeners();
  }

  // this function clears the app state
  void clearAppState() {
    _channelNames = [];
    _dataHandler = null;
    _staticCommentData = [];
    if (_device != null) {
      _device!.disconnect();
    }
    _staticData = [];
  }
}