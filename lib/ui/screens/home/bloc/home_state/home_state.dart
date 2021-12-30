import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {}

class EmptyState extends HomeState {
  @override
  List<Object?> get props => [];
}

class LogConnectionState extends HomeState {
  final bool isConnected;

  LogConnectionState(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class LoadingState extends HomeState {
  @override
  List<Object?> get props => [];
}
