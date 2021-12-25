///
//  Generated code. Do not modify.
//  source: models.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'communication.pb.dart' as $0;

class Settings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Settings', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'appName', protoName: 'appName')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ip')
    ..pc<Tab>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tabs', $pb.PbFieldType.PM, subBuilder: Tab.create)
    ..hasRequiredFields = false
  ;

  Settings._() : super();
  factory Settings({
    $core.String? appName,
    $core.String? ip,
    $core.Iterable<Tab>? tabs,
  }) {
    final _result = create();
    if (appName != null) {
      _result.appName = appName;
    }
    if (ip != null) {
      _result.ip = ip;
    }
    if (tabs != null) {
      _result.tabs.addAll(tabs);
    }
    return _result;
  }
  factory Settings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Settings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Settings clone() => Settings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Settings copyWith(void Function(Settings) updates) => super.copyWith((message) => updates(message as Settings)) as Settings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Settings create() => Settings._();
  Settings createEmptyInstance() => create();
  static $pb.PbList<Settings> createRepeated() => $pb.PbList<Settings>();
  @$core.pragma('dart2js:noInline')
  static Settings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Settings>(create);
  static Settings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appName => $_getSZ(0);
  @$pb.TagNumber(1)
  set appName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAppName() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get ip => $_getSZ(1);
  @$pb.TagNumber(2)
  set ip($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIp() => $_has(1);
  @$pb.TagNumber(2)
  void clearIp() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<Tab> get tabs => $_getList(2);
}

class Tab extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Tab', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOM<TabFilter>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'filter', subBuilder: TabFilter.create)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showOnlySearches', protoName: 'showOnlySearches')
    ..hasRequiredFields = false
  ;

  Tab._() : super();
  factory Tab({
    $core.int? id,
    $core.String? name,
    TabFilter? filter,
    $core.bool? showOnlySearches,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (filter != null) {
      _result.filter = filter;
    }
    if (showOnlySearches != null) {
      _result.showOnlySearches = showOnlySearches;
    }
    return _result;
  }
  factory Tab.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Tab.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Tab clone() => Tab()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Tab copyWith(void Function(Tab) updates) => super.copyWith((message) => updates(message as Tab)) as Tab; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Tab create() => Tab._();
  Tab createEmptyInstance() => create();
  static $pb.PbList<Tab> createRepeated() => $pb.PbList<Tab>();
  @$core.pragma('dart2js:noInline')
  static Tab getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tab>(create);
  static Tab? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  TabFilter get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter(TabFilter v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => clearField(3);
  @$pb.TagNumber(3)
  TabFilter ensureFilter() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get showOnlySearches => $_getBF(3);
  @$pb.TagNumber(4)
  set showOnlySearches($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasShowOnlySearches() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowOnlySearches() => clearField(4);
}

class TabFilter extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TabFilter', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..pc<$0.LogTag>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tags', $pb.PbFieldType.PM, subBuilder: $0.LogTag.create)
    ..pc<$0.LogLevel>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'logLevels', $pb.PbFieldType.PM, protoName: 'logLevels', subBuilder: $0.LogLevel.create)
    ..hasRequiredFields = false
  ;

  TabFilter._() : super();
  factory TabFilter({
    $core.String? name,
    $core.Iterable<$0.LogTag>? tags,
    $core.Iterable<$0.LogLevel>? logLevels,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (tags != null) {
      _result.tags.addAll(tags);
    }
    if (logLevels != null) {
      _result.logLevels.addAll(logLevels);
    }
    return _result;
  }
  factory TabFilter.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TabFilter.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TabFilter clone() => TabFilter()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TabFilter copyWith(void Function(TabFilter) updates) => super.copyWith((message) => updates(message as TabFilter)) as TabFilter; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TabFilter create() => TabFilter._();
  TabFilter createEmptyInstance() => create();
  static $pb.PbList<TabFilter> createRepeated() => $pb.PbList<TabFilter>();
  @$core.pragma('dart2js:noInline')
  static TabFilter getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TabFilter>(create);
  static TabFilter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$0.LogTag> get tags => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$0.LogLevel> get logLevels => $_getList(2);
}

