import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';

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
