import 'package:equatable/equatable.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

abstract class HomeEvent extends Equatable {}

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

class NewFilterEvent extends HomeEvent {
  final String filter;

  NewFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class AddTabEvent extends HomeEvent {
  final TabFilter filter;

  AddTabEvent(this.filter);

  @override
  List<Object?> get props => [];
}
