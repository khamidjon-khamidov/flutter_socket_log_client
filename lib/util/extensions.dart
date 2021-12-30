import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

extension Filter on TabFilter {
  List<FilteredLog> applyFilter(List<LogMessage> logs) {
    return logs
        .map((logMessage) {
          // if filtered log levels is empty or filtered log levels contains logLevel of message
          // then log level is valid
          bool isLogLevelMatch = logLevels.isEmpty || logLevels.contains(logMessage.logLevel);

          // if filtered log tags is empty or intersection of filtered tags and logMessage.logTags,
          // then log tag is valid
          bool isLogTagMatch =
              tags.isEmpty || tags.toSet().intersection(logMessage.logTags.toSet()).isNotEmpty;

          if (!(isLogTagMatch && isLogLevelMatch)) {
            return _createFilteredLog(logMessage, false, false);
          }

          // if search is empty or message contains search filter
          // then search is valid
          bool isSearchMatch = search.isEmpty || logMessage.message.contains(search);

          return _createFilteredLog(logMessage, true, isSearchMatch);
        })
        .where((filteredLog) =>
            filteredLog.isFilterMatch && (!showOnlySearches || filteredLog.isSearchMatch))
        .toList();
  }
}

FilteredLog _createFilteredLog(
  LogMessage logMessage,
  bool isFilterMatch,
  bool isSearchMatch,
) {
  return FilteredLog.create()
    ..logMessage = logMessage
    ..isFilterMatch = isFilterMatch
    ..isSearchMatch = isSearchMatch;
}
