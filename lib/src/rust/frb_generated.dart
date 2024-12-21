// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/data_handler.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'frb_generated.io.dart'
    if (dart.library.js_interop) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Initialize flutter_rust_bridge in mock mode.
  /// No libraries for FFI are loaded.
  static void initMock({
    required RustLibApi api,
  }) {
    instance.initMockImpl(
      api: api,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {
    await api.crateApiInitInitApp();
  }

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.6.0';

  @override
  int get rustContentHash => 1266387366;

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib_baby_monitoring_app',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  Uint16List crateApiDataHandlerDataHandlerAutoAccessorGetDataList(
      {required DataHandler that});

  bool crateApiDataHandlerDataHandlerAutoAccessorGetError(
      {required DataHandler that});

  void crateApiDataHandlerDataHandlerAutoAccessorSetDataList(
      {required DataHandler that, required Uint16List dataList});

  void crateApiDataHandlerDataHandlerAutoAccessorSetError(
      {required DataHandler that, required bool error});

  DataHandler crateApiDataHandlerDataHandlerNew(
      {required List<RustStreamSink<int>> streamSinks,
      required int numChannels,
      required String dir,
      required String filename});

  Future<void> crateApiDataHandlerDataHandlerProcess(
      {required DataHandler that, required List<int> bytes});

  Future<List<Uint16List>> crateApiDataHandlerDataHandlerReadDataCsv(
      {required DataHandler that});

  Future<void> crateApiInitInitApp();

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_BoxError;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_BoxError;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_BoxErrorPtr;

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_DataHandler;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_DataHandler;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_DataHandlerPtr;
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  Uint16List crateApiDataHandlerDataHandlerAutoAccessorGetDataList(
      {required DataHandler that}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
            that, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 1)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_prim_u_16_strict,
        decodeErrorData: null,
      ),
      constMeta:
          kCrateApiDataHandlerDataHandlerAutoAccessorGetDataListConstMeta,
      argValues: [that],
      apiImpl: this,
    ));
  }

  TaskConstMeta
      get kCrateApiDataHandlerDataHandlerAutoAccessorGetDataListConstMeta =>
          const TaskConstMeta(
            debugName: "DataHandler_auto_accessor_get_data_list",
            argNames: ["that"],
          );

  @override
  bool crateApiDataHandlerDataHandlerAutoAccessorGetError(
      {required DataHandler that}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
            that, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 2)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_bool,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiDataHandlerDataHandlerAutoAccessorGetErrorConstMeta,
      argValues: [that],
      apiImpl: this,
    ));
  }

  TaskConstMeta
      get kCrateApiDataHandlerDataHandlerAutoAccessorGetErrorConstMeta =>
          const TaskConstMeta(
            debugName: "DataHandler_auto_accessor_get_error",
            argNames: ["that"],
          );

  @override
  void crateApiDataHandlerDataHandlerAutoAccessorSetDataList(
      {required DataHandler that, required Uint16List dataList}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
            that, serializer);
        sse_encode_list_prim_u_16_strict(dataList, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 3)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta:
          kCrateApiDataHandlerDataHandlerAutoAccessorSetDataListConstMeta,
      argValues: [that, dataList],
      apiImpl: this,
    ));
  }

  TaskConstMeta
      get kCrateApiDataHandlerDataHandlerAutoAccessorSetDataListConstMeta =>
          const TaskConstMeta(
            debugName: "DataHandler_auto_accessor_set_data_list",
            argNames: ["that", "dataList"],
          );

  @override
  void crateApiDataHandlerDataHandlerAutoAccessorSetError(
      {required DataHandler that, required bool error}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
            that, serializer);
        sse_encode_bool(error, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 4)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiDataHandlerDataHandlerAutoAccessorSetErrorConstMeta,
      argValues: [that, error],
      apiImpl: this,
    ));
  }

  TaskConstMeta
      get kCrateApiDataHandlerDataHandlerAutoAccessorSetErrorConstMeta =>
          const TaskConstMeta(
            debugName: "DataHandler_auto_accessor_set_error",
            argNames: ["that", "error"],
          );

  @override
  DataHandler crateApiDataHandlerDataHandlerNew(
      {required List<RustStreamSink<int>> streamSinks,
      required int numChannels,
      required String dir,
      required String filename}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_list_StreamSink_i_32_Sse(streamSinks, serializer);
        sse_encode_u_32(numChannels, serializer);
        sse_encode_String(dir, serializer);
        sse_encode_String(filename, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 5)!;
      },
      codec: SseCodec(
        decodeSuccessData:
            sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiDataHandlerDataHandlerNewConstMeta,
      argValues: [streamSinks, numChannels, dir, filename],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiDataHandlerDataHandlerNewConstMeta =>
      const TaskConstMeta(
        debugName: "DataHandler_new",
        argNames: ["streamSinks", "numChannels", "dir", "filename"],
      );

  @override
  Future<void> crateApiDataHandlerDataHandlerProcess(
      {required DataHandler that, required List<int> bytes}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
            that, serializer);
        sse_encode_list_prim_u_8_loose(bytes, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 6, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiDataHandlerDataHandlerProcessConstMeta,
      argValues: [that, bytes],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiDataHandlerDataHandlerProcessConstMeta =>
      const TaskConstMeta(
        debugName: "DataHandler_process",
        argNames: ["that", "bytes"],
      );

  @override
  Future<List<Uint16List>> crateApiDataHandlerDataHandlerReadDataCsv(
      {required DataHandler that}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
            that, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 7, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_list_prim_u_16_strict,
        decodeErrorData:
            sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBoxdynError,
      ),
      constMeta: kCrateApiDataHandlerDataHandlerReadDataCsvConstMeta,
      argValues: [that],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiDataHandlerDataHandlerReadDataCsvConstMeta =>
      const TaskConstMeta(
        debugName: "DataHandler_read_data_csv",
        argNames: ["that"],
      );

  @override
  Future<void> crateApiInitInitApp() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 8, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiInitInitAppConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiInitInitAppConstMeta => const TaskConstMeta(
        debugName: "init_app",
        argNames: [],
      );

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_BoxError => wire
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBoxdynError;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_BoxError => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBoxdynError;

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_DataHandler => wire
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_DataHandler => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return AnyhowException(raw as String);
  }

  @protected
  BoxError
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBoxdynError(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return BoxErrorImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  DataHandler
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return DataHandlerImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  DataHandler
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return DataHandlerImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  DataHandler
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return DataHandlerImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  BoxError
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBoxdynError(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return BoxErrorImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  DataHandler
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return DataHandlerImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  RustStreamSink<int> dco_decode_StreamSink_i_32_Sse(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    throw UnimplementedError();
  }

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  bool dco_decode_bool(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as bool;
  }

  @protected
  int dco_decode_i_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  List<RustStreamSink<int>> dco_decode_list_StreamSink_i_32_Sse(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_StreamSink_i_32_Sse).toList();
  }

  @protected
  List<Uint16List> dco_decode_list_list_prim_u_16_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>)
        .map(dco_decode_list_prim_u_16_strict)
        .toList();
  }

  @protected
  Uint16List dco_decode_list_prim_u_16_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint16List;
  }

  @protected
  List<int> dco_decode_list_prim_u_8_loose(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as List<int>;
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  int dco_decode_u_16(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  int dco_decode_u_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  BigInt dco_decode_usize(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeU64(raw);
  }

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_String(deserializer);
    return AnyhowException(inner);
  }

  @protected
  BoxError
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBoxdynError(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return BoxErrorImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  DataHandler
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return DataHandlerImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  DataHandler
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return DataHandlerImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  DataHandler
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return DataHandlerImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  BoxError
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBoxdynError(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return BoxErrorImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  DataHandler
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return DataHandlerImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  RustStreamSink<int> sse_decode_StreamSink_i_32_Sse(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    throw UnimplementedError('Unreachable ()');
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  List<RustStreamSink<int>> sse_decode_list_StreamSink_i_32_Sse(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <RustStreamSink<int>>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_StreamSink_i_32_Sse(deserializer));
    }
    return ans_;
  }

  @protected
  List<Uint16List> sse_decode_list_list_prim_u_16_strict(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <Uint16List>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_list_prim_u_16_strict(deserializer));
    }
    return ans_;
  }

  @protected
  Uint16List sse_decode_list_prim_u_16_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint16List(len_);
  }

  @protected
  List<int> sse_decode_list_prim_u_8_loose(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  int sse_decode_u_16(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint16();
  }

  @protected
  int sse_decode_u_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint32();
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getBigUint64();
  }

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.message, serializer);
  }

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBoxdynError(
          BoxError self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as BoxErrorImpl).frbInternalSseEncode(move: true), serializer);
  }

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          DataHandler self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as DataHandlerImpl).frbInternalSseEncode(move: true), serializer);
  }

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          DataHandler self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as DataHandlerImpl).frbInternalSseEncode(move: false),
        serializer);
  }

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          DataHandler self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as DataHandlerImpl).frbInternalSseEncode(move: false),
        serializer);
  }

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBoxdynError(
          BoxError self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as BoxErrorImpl).frbInternalSseEncode(move: null), serializer);
  }

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          DataHandler self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as DataHandlerImpl).frbInternalSseEncode(move: null), serializer);
  }

  @protected
  void sse_encode_StreamSink_i_32_Sse(
      RustStreamSink<int> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(
        self.setupAndSerialize(
            codec: SseCodec(
          decodeSuccessData: sse_decode_i_32,
          decodeErrorData: sse_decode_AnyhowException,
        )),
        serializer);
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }

  @protected
  void sse_encode_list_StreamSink_i_32_Sse(
      List<RustStreamSink<int>> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_StreamSink_i_32_Sse(item, serializer);
    }
  }

  @protected
  void sse_encode_list_list_prim_u_16_strict(
      List<Uint16List> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_list_prim_u_16_strict(item, serializer);
    }
  }

  @protected
  void sse_encode_list_prim_u_16_strict(
      Uint16List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint16List(self);
  }

  @protected
  void sse_encode_list_prim_u_8_loose(
      List<int> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer
        .putUint8List(self is Uint8List ? self : Uint8List.fromList(self));
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_u_16(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint16(self);
  }

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint32(self);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putBigUint64(self);
  }
}

@sealed
class BoxErrorImpl extends RustOpaque implements BoxError {
  // Not to be used by end users
  BoxErrorImpl.frbInternalDcoDecode(List<dynamic> wire)
      : super.frbInternalDcoDecode(wire, _kStaticData);

  // Not to be used by end users
  BoxErrorImpl.frbInternalSseDecode(BigInt ptr, int externalSizeOnNative)
      : super.frbInternalSseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_BoxError,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_BoxError,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_BoxErrorPtr,
  );
}

@sealed
class DataHandlerImpl extends RustOpaque implements DataHandler {
  // Not to be used by end users
  DataHandlerImpl.frbInternalDcoDecode(List<dynamic> wire)
      : super.frbInternalDcoDecode(wire, _kStaticData);

  // Not to be used by end users
  DataHandlerImpl.frbInternalSseDecode(BigInt ptr, int externalSizeOnNative)
      : super.frbInternalSseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_DataHandler,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_DataHandler,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_DataHandlerPtr,
  );

  Uint16List get dataList => RustLib.instance.api
          .crateApiDataHandlerDataHandlerAutoAccessorGetDataList(
        that: this,
      );

  bool get error =>
      RustLib.instance.api.crateApiDataHandlerDataHandlerAutoAccessorGetError(
        that: this,
      );

  set dataList(Uint16List dataList) => RustLib.instance.api
      .crateApiDataHandlerDataHandlerAutoAccessorSetDataList(
          that: this, dataList: dataList);

  set error(bool error) =>
      RustLib.instance.api.crateApiDataHandlerDataHandlerAutoAccessorSetError(
          that: this, error: error);

  Future<void> process({required List<int> bytes}) => RustLib.instance.api
      .crateApiDataHandlerDataHandlerProcess(that: this, bytes: bytes);

  Future<List<Uint16List>> readDataCsv() =>
      RustLib.instance.api.crateApiDataHandlerDataHandlerReadDataCsv(
        that: this,
      );
}
