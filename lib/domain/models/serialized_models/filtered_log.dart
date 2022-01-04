import 'package:flutter_socket_log_client/domain/models/proto_models/communication.pb.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filtered_log.g.dart';

@JsonSerializable(explicitToJson: true)
class FilteredLog {
  final int id;
  @JsonKey(fromJson: _logMessageFromJson, toJson: _logMessageToJson)
  final LogMessage logMessage;
  final bool isSearchMatch;

  factory FilteredLog.fromJson(Map<String, dynamic> json) => _$FilteredLogFromJson(json);

  Map<String, dynamic> toJson() => _$FilteredLogToJson(this);

  FilteredLog({
    required this.id,
    required this.logMessage,
    required this.isSearchMatch,
  });

  static LogMessage _logMessageFromJson(Map<String, dynamic> json) =>
      LogMessage.fromJson(json.toString());

  static Map<String, dynamic> _logMessageToJson(LogMessage logMessage) =>
      logMessage.writeToJsonMap();
}
