import 'package:equatable/equatable.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

abstract class HomeEvent extends Equatable {}

// ******** Outside Bloc Event *********

class SetIpEvent extends HomeEvent {
  final String ip;

  SetIpEvent(this.ip);

  @override
  List<Object?> get props => [ip];
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
