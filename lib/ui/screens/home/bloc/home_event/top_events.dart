import 'package:flutter_socket_log_client/domain/models/proto_models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/tab_filter.dart';

import 'home_event.dart';

class UpdateAppSettingsEvent extends HomeEvent {
  final String ip;
  final String appName;
  final bool shouldClearSettings;

  UpdateAppSettingsEvent({
    required this.ip,
    required this.appName,
    required this.shouldClearSettings,
  });

  @override
  List<Object?> get props => [ip, appName, shouldClearSettings];
}

class ToggleConnectionStateEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

// ************* TAB EVENTS **************
class AddTabEvent extends HomeEvent {
  final TabFilter filter;

  AddTabEvent(this.filter);

  @override
  List<Object?> get props => [];
}

class AddNewTabEvent extends HomeEvent {
  final String tabName;
  final Set<LogTag> selectedLogTags;
  final Set<LogLevel> selectedLogLevels;

  AddNewTabEvent({
    required this.tabName,
    required this.selectedLogTags,
    required this.selectedLogLevels,
  });

  @override
  List<Object?> get props => [
        tabName,
        selectedLogLevels,
        selectedLogTags,
      ];
}

class EditTabEvent extends HomeEvent {
  final SingleTab tab;
  final String newName;
  final Set<LogTag> selectedTags;
  final Set<LogLevel> selectedLogLevels;

  EditTabEvent({
    required this.tab,
    required this.newName,
    required this.selectedLogLevels,
    required this.selectedTags,
  });

  @override
  List<Object?> get props => [
        tab,
        newName,
        selectedLogLevels,
        selectedTags,
      ];
}

class CloseTabEvent extends HomeEvent {
  final SingleTab tab;

  CloseTabEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class TabSelectedEvent extends HomeEvent {
  final SingleTab tab;

  TabSelectedEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class ShowEditTabDialogEvent extends HomeEvent {
  final SingleTab tab;

  ShowEditTabDialogEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class GetTabsEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

// ******** Internal Bloc Events *********
class ConnectionToggledEvent extends HomeEvent {
  final bool isConnected;

  ConnectionToggledEvent(this.isConnected);

  @override
  List<Object?> get props => [];
}

class AppBarDataReceivedEvent extends HomeEvent {
  final String appName;
  final String ip;

  AppBarDataReceivedEvent(
    this.appName,
    this.ip,
  );

  @override
  List<Object?> get props => [appName, ip];
}
