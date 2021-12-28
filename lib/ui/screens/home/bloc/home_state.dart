import 'package:equatable/equatable.dart';
import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

abstract class HomeState extends Equatable {}

class EmptyState extends HomeState {
  @override
  List<Object?> get props => [];
}

class TabsState extends HomeState {
  final int selectedTabId;
  final List<Tab> tabs;

  TabsState({
    required this.selectedTabId,
    required this.tabs,
  });

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

class LogConnectionState extends HomeState {
  final bool isConnected;

  LogConnectionState(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class BottomBarState extends HomeState {
  final String filter;
  final bool showOnlySearches;

  BottomBarState(this.filter, this.showOnlySearches);

  @override
  List<Object?> get props => [filter, showOnlySearches];
}

class MessagesState extends HomeState {
  final int tabId;
  final List<LogMessage> messages;

  MessagesState({
    required this.tabId,
    required this.messages,
  });

  @override
  List<Object?> get props => [];
}

class LoadingState extends HomeState {
  @override
  List<Object?> get props => [];
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
  final Tab tab;
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
