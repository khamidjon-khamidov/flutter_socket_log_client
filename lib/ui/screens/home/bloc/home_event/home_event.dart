import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class ShowInputIpDialogEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class ShowAddTabDialogEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class ClearMessagesEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
