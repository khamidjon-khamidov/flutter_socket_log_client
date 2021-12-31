import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/home_event.dart';

class ShowOnlySearchesEvent extends HomeEvent {
  final String showOnlySearches;

  ShowOnlySearchesEvent(this.showOnlySearches);

  @override
  List<Object?> get props => [showOnlySearches];
}

class SearchEvent extends HomeEvent {
  final String search;

  SearchEvent(this.search);

  @override
  List<Object?> get props => [search];
}
