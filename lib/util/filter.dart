import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';

class Filter {
  final String search;
  final bool showOnlySearches;
  final List<LogTag> logTags;
  final List<LogLevel> logLevels;

  Filter({
    required this.search,
    required this.showOnlySearches,
    required this.logTags,
    required this.logLevels,
  });

  Filter copyWith({
    final String? search,
    final bool? showOnlySearches,
    final List<LogTag>? logTags,
    final List<LogLevel>? logLevels,
  }) =>
      Filter(
        search: search ?? this.search,
        showOnlySearches: showOnlySearches ?? this.showOnlySearches,
        logTags: logTags ?? this.logTags,
        logLevels: logLevels ?? this.logLevels,
      );
}
