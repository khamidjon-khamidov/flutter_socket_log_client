import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filtered_log.g.dart';

@JsonSerializable(explicitToJson: true)
class FilteredLog {
  @JsonKey(fromJson: _logMessageFromJson, toJson: _logMessageToJson)
  final LogMessage logMessage;
  final bool isFilterMatch;
  final bool isSearchMatch;

  factory FilteredLog.fromJson(Map<String, dynamic> json) => _$FilteredLogFromJson(json);

  Map<String, dynamic> toJson() => _$FilteredLogToJson(this);

  FilteredLog({
    required this.logMessage,
    required this.isSearchMatch,
    required this.isFilterMatch,
  });

  static LogMessage _logMessageFromJson(Map<String, dynamic> json) =>
      LogMessage.fromJson(json.toString());

  static Map<String, dynamic> _logMessageToJson(LogMessage logMessage) =>
      logMessage.writeToJsonMap();
}
