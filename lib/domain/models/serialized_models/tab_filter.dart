import 'package:flutter_socket_log_client/domain/models/proto_models/communication.pb.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tab_filter.g.dart';

@JsonSerializable(explicitToJson: true)
class TabFilter {
  String search;
  @JsonKey(fromJson: _logTagFromJson, toJson: _logTagToJson)
  final Set<LogTag> tags;
  @JsonKey(fromJson: _logLevelFromJson, toJson: _logLevelToJson)
  final Set<LogLevel> logLevels;
  bool showOnlySearches;

  void setSearch(String search) => this.search = search;
  void setShowOnlySearches(bool showOnlySearches) => this.showOnlySearches = showOnlySearches;

  factory TabFilter.defaultFilter() => TabFilter(
        '',
        false,
        tags: {},
        logLevels: {},
      );

  factory TabFilter.fromJson(Map<String, dynamic> json) => _$TabFilterFromJson(json);

  Map<String, dynamic> toJson() => _$TabFilterToJson(this);

  TabFilter(
    this.search,
    this.showOnlySearches, {
    required this.tags,
    required this.logLevels,
  });

  TabFilter copyWithCustom({
    String? search,
    Set<LogTag>? tags,
    Set<LogLevel>? logLevels,
    bool? showOnlySearches,
  }) {
    return TabFilter(
      search ?? this.search,
      showOnlySearches ?? this.showOnlySearches,
      tags: tags ?? this.tags,
      logLevels: logLevels ?? this.logLevels,
    );
  }

  static Set<LogTag> _logTagFromJson(Map<String, dynamic> jsonMap) =>
      jsonMap.values.map<LogTag>((json) => LogTag.fromJson(json)).toSet();

  static Map<String, dynamic> _logTagToJson(Set<LogTag> logTags) =>
      {for (var logTag in logTags) logTag.name: logTag.writeToJson()};

  static Set<LogLevel> _logLevelFromJson(Map<String, dynamic> jsonMap) =>
      jsonMap.values.map<LogLevel>((json) => LogLevel.fromJson(json)).toSet();

  static Map<String, dynamic> _logLevelToJson(Set<LogLevel> logLevels) =>
      {for (var logLevel in logLevels) logLevel.name: logLevel.writeToJson()};
}
