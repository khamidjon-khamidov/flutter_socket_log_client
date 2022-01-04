import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter_socket_log_client/base/highlight_log_controller.dart';
import 'package:flutter_socket_log_client/domain/models/proto_models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/filtered_log.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';

extension Filter on SingleTab {
  List<FilteredLog> applyFilter(
      List<LogMessage> logs, HighlightLogController highlightLogController) {
    List<int> matchedLogIndexes = [];
    List<FilteredLog> resultLogs = logs
        .where((logMessage) {
          // if filtered log levels is empty or filtered log levels contains logLevel of message
          // then log level is valid
          bool isLogLevelMatch =
              filter.logLevels.isEmpty || filter.logLevels.contains(logMessage.logLevel);

          // if filtered log tags is empty or intersection of filtered tags and logMessage.logTags,
          // then log tag is valid
          bool isLogTagMatch = filter.tags.isEmpty ||
              filter.tags.intersection(logMessage.logTags.toSet()).isNotEmpty;

          return isLogTagMatch && isLogLevelMatch;
        })
        .mapIndexed<FilteredLog>((index, logMessage) {
          // if search is empty or message contains search filter
          // then search is valid
          bool isSearchMatch = filter.search.isEmpty ||
              logMessage.message.toLowerCase().contains(filter.search.toLowerCase());

          if (isSearchMatch && filter.search.isNotEmpty) {
            // matchedLogIndexes.add(index);
            matchedLogIndexes.add(logs.length - index - 1);
          }
          return FilteredLog(
            id: logs.length - index - 1,
            logMessage: logMessage,
            isSearchMatch: isSearchMatch,
          );
        })
        .where((filteredLog) => !filter.showOnlySearches || filteredLog.isSearchMatch)
        .toList();

    highlightLogController.setAllMatchedIndexes(id, matchedLogIndexes);
    return resultLogs;
  }
}
