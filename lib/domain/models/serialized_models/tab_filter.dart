import 'package:flutter_socket_log_client/domain/models/remote_models/log_level.dart';
import 'package:flutter_socket_log_client/domain/models/remote_models/log_tag.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tab_filter.g.dart';

@JsonSerializable(explicitToJson: true)
class TabFilter {
  String search;
  final Set<LogTag> tags;
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
}
