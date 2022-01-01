import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/home_event.dart';

class ShowOnlySearchesEvent extends HomeEvent {
  final Tab tab;
  final bool showOnlySearches;

  ShowOnlySearchesEvent(this.showOnlySearches, this.tab);

  @override
  List<Object?> get props => [showOnlySearches, tab];
}

class SearchEvent extends HomeEvent {
  final String search;
  final Tab tab;

  SearchEvent(this.search, this.tab);

  @override
  List<Object?> get props => [search, tab];
}
