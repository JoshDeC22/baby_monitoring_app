// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `create_file`, `filter`, `update_file`, `write_comment`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<DataHandler>>
abstract class DataHandler implements RustOpaqueInterface {
  Uint16List get dataList;

  bool get error;

  set dataList(Uint16List dataList);

  set error(bool error);

  factory DataHandler(
          {required List<RustStreamSink<int>> streamSinks,
          required int numChannels,
          required String dir,
          required String filename}) =>
      RustLib.instance.api.crateApiDataHandlerDataHandlerNew(
          streamSinks: streamSinks,
          numChannels: numChannels,
          dir: dir,
          filename: filename);

  Future<void> process({required List<int> bytes});

  static Future<(List<String>, List<Uint16List>, List<List<String>>)?>
      readDataCsv({required String fileDirectory}) =>
          RustLib.instance.api.crateApiDataHandlerDataHandlerReadDataCsv(
              fileDirectory: fileDirectory);

  Future<void> saveCommentsCsv(
      {required String comment, required DateTime timestamp});

  Future<void> saveDataCsv({required List<int> data});
}
