import 'package:equatable/equatable.dart';
import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

abstract class HomeState extends Equatable {}

class EmptyState extends HomeState {
  @override
  List<Object?> get props => [];
}

class TabsState extends HomeState {
  final List<Tab> tabs;

  TabsState(this.tabs);

  @override
  List<Object?> get props => [tabs];
}

class AppBarState extends HomeState {
  final String appName;
  final String ip;

  AppBarState({
    required this.appName,
    required this.ip,
  });

  @override
  List<Object?> get props => [appName, ip];
}

class ConnectionState extends HomeState {
  final bool isConnected;

  ConnectionState(this.isConnected);

  @override
  List<Object?> get props => [];
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
