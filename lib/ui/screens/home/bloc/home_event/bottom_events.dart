import 'package:flutter_socket_log_client/domain/models/move_highlighted_message_type.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/home_event.dart';

class ShowOnlySearchesEvent extends HomeEvent {
  final SingleTab tab;
  final bool showOnlySearches;

  ShowOnlySearchesEvent(this.showOnlySearches, this.tab);

  @override
  List<Object?> get props => [showOnlySearches, tab];
}

class SearchEvent extends HomeEvent {
  final String search;
  final SingleTab tab;

  SearchEvent(this.search, this.tab);

  @override
  List<Object?> get props => [search, tab];
}

class ChangeHighlightedMessageEvent extends HomeEvent {
  final ChangeHighlightedMessageType changeHighlightedMessageType;

  ChangeHighlightedMessageEvent(
    this.changeHighlightedMessageType,
  );

  @override
  List<Object?> get props => [changeHighlightedMessageType];
}
