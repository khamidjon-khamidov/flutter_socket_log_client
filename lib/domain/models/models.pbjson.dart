///
//  Generated code. Do not modify.
//  source: models.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use filteredLogDescriptor instead')
const FilteredLog$json = const {
  '1': 'FilteredLog',
  '2': const [
    const {'1': 'logMessage', '3': 1, '4': 1, '5': 11, '6': '.communication.LogMessage', '10': 'logMessage'},
    const {'1': 'isMatch', '3': 2, '4': 1, '5': 8, '10': 'isMatch'},
  ],
};

/// Descriptor for `FilteredLog`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List filteredLogDescriptor = $convert.base64Decode('CgtGaWx0ZXJlZExvZxI5Cgpsb2dNZXNzYWdlGAEgASgLMhkuY29tbXVuaWNhdGlvbi5Mb2dNZXNzYWdlUgpsb2dNZXNzYWdlEhgKB2lzTWF0Y2gYAiABKAhSB2lzTWF0Y2g=');
@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = const {
  '1': 'Settings',
  '2': const [
    const {'1': 'appName', '3': 1, '4': 1, '5': 9, '10': 'appName'},
    const {'1': 'ip', '3': 2, '4': 1, '5': 9, '10': 'ip'},
    const {'1': 'tabs', '3': 3, '4': 3, '5': 11, '6': '.Tab', '10': 'tabs'},
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode('CghTZXR0aW5ncxIYCgdhcHBOYW1lGAEgASgJUgdhcHBOYW1lEg4KAmlwGAIgASgJUgJpcBIYCgR0YWJzGAMgAygLMgQuVGFiUgR0YWJz');
@$core.Deprecated('Use tabDescriptor instead')
const Tab$json = const {
  '1': 'Tab',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'filter', '3': 3, '4': 1, '5': 11, '6': '.TabFilter', '10': 'filter'},
  ],
};

/// Descriptor for `Tab`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tabDescriptor = $convert.base64Decode('CgNUYWISDgoCaWQYASABKAVSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSIgoGZmlsdGVyGAMgASgLMgouVGFiRmlsdGVyUgZmaWx0ZXI=');
@$core.Deprecated('Use tabFilterDescriptor instead')
const TabFilter$json = const {
  '1': 'TabFilter',
  '2': const [
    const {'1': 'search', '3': 1, '4': 1, '5': 9, '10': 'search'},
    const {'1': 'tags', '3': 2, '4': 3, '5': 11, '6': '.communication.LogTag', '10': 'tags'},
    const {'1': 'logLevels', '3': 3, '4': 3, '5': 11, '6': '.communication.LogLevel', '10': 'logLevels'},
    const {'1': 'showOnlySearches', '3': 4, '4': 1, '5': 8, '10': 'showOnlySearches'},
  ],
};

/// Descriptor for `TabFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tabFilterDescriptor = $convert.base64Decode('CglUYWJGaWx0ZXISFgoGc2VhcmNoGAEgASgJUgZzZWFyY2gSKQoEdGFncxgCIAMoCzIVLmNvbW11bmljYXRpb24uTG9nVGFnUgR0YWdzEjUKCWxvZ0xldmVscxgDIAMoCzIXLmNvbW11bmljYXRpb24uTG9nTGV2ZWxSCWxvZ0xldmVscxIqChBzaG93T25seVNlYXJjaGVzGAQgASgIUhBzaG93T25seVNlYXJjaGVz');
