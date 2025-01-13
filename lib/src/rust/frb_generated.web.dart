// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

// Static analysis wrongly picks the IO variant, thus ignore this
// ignore_for_file: argument_type_not_assignable

import 'api/data_handler.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_DataHandlerPtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  DataHandler
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          dynamic raw);

  @protected
  DataHandler
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          dynamic raw);

  @protected
  DataHandler
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          dynamic raw);

  @protected
  DataHandler
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          dynamic raw);

  @protected
  RustStreamSink<int> dco_decode_StreamSink_i_32_Sse(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  (List<String>, List<Uint16List>)
      dco_decode_box_autoadd_record_list_string_list_list_prim_u_16_strict(
          dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  List<RustStreamSink<int>> dco_decode_list_StreamSink_i_32_Sse(dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<Uint16List> dco_decode_list_list_prim_u_16_strict(dynamic raw);

  @protected
  List<int> dco_decode_list_prim_u_16_loose(dynamic raw);

  @protected
  Uint16List dco_decode_list_prim_u_16_strict(dynamic raw);

  @protected
  List<int> dco_decode_list_prim_u_8_loose(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  (List<String>, List<Uint16List>)?
      dco_decode_opt_box_autoadd_record_list_string_list_list_prim_u_16_strict(
          dynamic raw);

  @protected
  (List<String>, List<Uint16List>)
      dco_decode_record_list_string_list_list_prim_u_16_strict(dynamic raw);

  @protected
  int dco_decode_u_16(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  BigInt dco_decode_usize(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  DataHandler
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          SseDeserializer deserializer);

  @protected
  DataHandler
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          SseDeserializer deserializer);

  @protected
  DataHandler
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          SseDeserializer deserializer);

  @protected
  DataHandler
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          SseDeserializer deserializer);

  @protected
  RustStreamSink<int> sse_decode_StreamSink_i_32_Sse(
      SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  (List<String>, List<Uint16List>)
      sse_decode_box_autoadd_record_list_string_list_list_prim_u_16_strict(
          SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  List<RustStreamSink<int>> sse_decode_list_StreamSink_i_32_Sse(
      SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<Uint16List> sse_decode_list_list_prim_u_16_strict(
      SseDeserializer deserializer);

  @protected
  List<int> sse_decode_list_prim_u_16_loose(SseDeserializer deserializer);

  @protected
  Uint16List sse_decode_list_prim_u_16_strict(SseDeserializer deserializer);

  @protected
  List<int> sse_decode_list_prim_u_8_loose(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  (List<String>, List<Uint16List>)?
      sse_decode_opt_box_autoadd_record_list_string_list_list_prim_u_16_strict(
          SseDeserializer deserializer);

  @protected
  (List<String>, List<Uint16List>)
      sse_decode_record_list_string_list_list_prim_u_16_strict(
          SseDeserializer deserializer);

  @protected
  int sse_decode_u_16(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          DataHandler self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          DataHandler self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          DataHandler self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          DataHandler self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_i_32_Sse(
      RustStreamSink<int> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_record_list_string_list_list_prim_u_16_strict(
      (List<String>, List<Uint16List>) self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_list_StreamSink_i_32_Sse(
      List<RustStreamSink<int>> self, SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_list_prim_u_16_strict(
      List<Uint16List> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_16_loose(
      List<int> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_16_strict(
      Uint16List self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_loose(List<int> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_record_list_string_list_list_prim_u_16_strict(
      (List<String>, List<Uint16List>)? self, SseSerializer serializer);

  @protected
  void sse_encode_record_list_string_list_list_prim_u_16_strict(
      (List<String>, List<Uint16List>) self, SseSerializer serializer);

  @protected
  void sse_encode_u_16(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
              ptr);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
extension type RustLibWasmModule._(JSObject _) implements JSObject {
  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerDataHandler(
          int ptr);
}
