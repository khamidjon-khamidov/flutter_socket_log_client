import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/offline/tab.dart';

import 'home_state.dart';

class TabsState extends HomeState {
  final int selectedTabId;
  final List<SingleTab> tabs;

  TabsState({
    required this.selectedTabId,
    required this.tabs,
  }) {
    tabs.sort((a, b) => a.id - b.id);
  }

  @override
  List<Object?> get props => [selectedTabId, tabs];
}

class AppBarDataState extends HomeState {
  final String appName;
  final String ip;

  AppBarDataState({
    required this.appName,
    required this.ip,
  });

  @override
  List<Object?> get props => [appName, ip];
}

class ShowInputIpDialogState extends HomeState {
  final String ip;
  final String appName;

  ShowInputIpDialogState({
    required this.ip,
    required this.appName,
  });

  @override
  List<Object?> get props => [ip, appName];
}

class ShowAddTabDialogState extends HomeState {
  final List<LogTag> allLogTags;
  final List<LogLevel> allLogLevels;

  ShowAddTabDialogState({
    required this.allLogTags,
    required this.allLogLevels,
  });

  @override
  List<Object?> get props => [allLogTags, allLogLevels];
}

class ShowEditTabDialogState extends HomeState {
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
