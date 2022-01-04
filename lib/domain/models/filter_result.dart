import 'package:flutter_socket_log_client/domain/models/serialized_models/filtered_log.dart';

class FilterResult {
  final List<FilteredLog> logs;
  final List<int> matchedLogIndexes;

  FilterResult({
    required this.logs,
    required this.matchedLogIndexes,
  });
}
