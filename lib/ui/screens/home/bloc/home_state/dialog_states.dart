import 'package:flutter_socket_log_client/domain/models/proto_models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';

import 'home_state.dart';

abstract class DialogState extends HomeState {}

class ShowInputIpDialogState extends DialogState {
  final String ip;
  final String appName;

  ShowInputIpDialogState({
    required this.ip,
    required this.appName,
  });

  @override
  List<Object?> get props => [ip, appName];
}

class ShowAddTabDialogState extends DialogState {
  final List<LogTag> allLogTags;
  final List<LogLevel> allLogLevels;

  ShowAddTabDialogState({
    required this.allLogTags,
    required this.allLogLevels,
  });

  @override
  List<Object?> get props => [allLogTags, allLogLevels];
}

class ShowEditTabDialogState extends DialogState {
  final SingleTab tab;
  final List<LogTag> allLogTags;
  final List<LogLevel> allLogLevels;

  ShowEditTabDialogState({
    required this.tab,
    required this.allLogTags,
    required this.allLogLevels,
  });

  @override
  List<Object?> get props => [tab, allLogTags, allLogLevels];
}
