import 'package:flutter_socket_log_client/domain/models/remote_models/log_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filtered_log.g.dart';

@JsonSerializable(explicitToJson: true)
class FilteredLog {
  final int id;
  final LogMessage logMessage;
  final bool isSearchMatch;

  factory FilteredLog.fromJson(Map<String, dynamic> json) => _$FilteredLogFromJson(json);

  Map<String, dynamic> toJson() => _$FilteredLogToJson(this);

  FilteredLog({
    required this.id,
    required this.logMessage,
    required this.isSearchMatch,
  });
}
