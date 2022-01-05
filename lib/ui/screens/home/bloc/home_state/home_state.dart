import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {}

class EmptyState extends HomeState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends HomeState {
  @override
  List<Object?> get props => [];
}
