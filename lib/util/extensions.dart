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

          // if search is empty or message contains search filter
          // then search is valid
          bool isSearchMatch = search.isEmpty || logMessage.message.contains(search);

          return _createFilteredLog(logMessage, isSearchMatch && isLogTagMatch && isLogLevelMatch);
        })
        .where((filteredLog) => !showOnlySearches || filteredLog.isMatch)
        .toList();
  }
}

FilteredLog _createFilteredLog(LogMessage logMessage, bool isMatch) {
  return FilteredLog.create()
    ..logMessage = logMessage
    ..isMatch = isMatch;
}
