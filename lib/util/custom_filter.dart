import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter_socket_log_client/domain/models/proto_models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/filtered_log.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/tab_filter.dart';

extension Filter on TabFilter {
  List<FilteredLog> applyFilter(List<LogMessage> logs) {
    return logs
        .where((logMessage) {
          // if filtered log levels is empty or filtered log levels contains logLevel of message
          // then log level is valid
          bool isLogLevelMatch = logLevels.isEmpty || logLevels.contains(logMessage.logLevel);

          // if filtered log tags is empty or intersection of filtered tags and logMessage.logTags,
          // then log tag is valid
          bool isLogTagMatch =
              tags.isEmpty || tags.intersection(logMessage.logTags.toSet()).isNotEmpty;

          return isLogTagMatch && isLogLevelMatch;
        })
        .mapIndexed<FilteredLog>((index, logMessage) {
          // if search is empty or message contains search filter
          // then search is valid
          bool isSearchMatch =
              search.isEmpty || logMessage.message.toLowerCase().contains(search.toLowerCase());

          return FilteredLog(
            id: index,
            logMessage: logMessage,
            isSearchMatch: isSearchMatch,
          );
        })
        .where((filteredLog) => !showOnlySearches || filteredLog.isSearchMatch)
        .toList();
  }
}
