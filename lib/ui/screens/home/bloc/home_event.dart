import 'package:equatable/equatable.dart';
import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

abstract class HomeEvent extends Equatable {}

// ******** Outside Bloc Event *********

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

class SetShowOnlySearchesEvent extends HomeEvent {
  final bool value;

  SetShowOnlySearchesEvent(this.value);

  @override
  List<Object?> get props => [];
}

class SearchEvent extends HomeEvent {
  final int tabId;
  final String filter;

  SearchEvent(this.tabId, this.filter);

  @override
  List<Object?> get props => [filter];
}

class AddTabEvent extends HomeEvent {
  final TabFilter filter;

  AddTabEvent(this.filter);

  @override
  List<Object?> get props => [];
}

class ShowInputIpDialogEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class ShowAddTabDialogEvent extends HomeEvent {
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

class GetTabsEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class TabSelectedEvent extends HomeEvent {
  final Tab tab;

  TabSelectedEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class CloseTabEvent extends HomeEvent {
  final Tab tab;

  CloseTabEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

// ******** Internal Bloc Events *********
abstract class InternalBlocEvent extends HomeEvent {}

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

///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
