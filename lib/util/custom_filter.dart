import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/offline/filtered_log.dart';
import 'package:flutter_socket_log_client/domain/models/offline/tab_filter.dart';

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
              tags.isEmpty || tags.intersection(logMessage.logTags.toSet()).isNotEmpty;

          if (!(isLogTagMatch && isLogLevelMatch)) {
            return FilteredLog(
              logMessage: logMessage,
              isSearchMatch: false,
              isFilterMatch: false,
            );
          }

          // if search is empty or message contains search filter
          // then search is valid
          bool isSearchMatch =
              search.isEmpty || logMessage.message.toLowerCase().contains(search.toLowerCase());

          return FilteredLog(
            logMessage: logMessage,
            isSearchMatch: isSearchMatch,
            isFilterMatch: true,
          );
        })
        .where((filteredLog) =>
            filteredLog.isFilterMatch && (!showOnlySearches || filteredLog.isSearchMatch))
        .toList();
  }
}
