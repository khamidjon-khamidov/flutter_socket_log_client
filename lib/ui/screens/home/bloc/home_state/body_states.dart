import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';

import 'home_state.dart';

class ReloadMessagesState extends HomeState {
  final int? highlightedMessageIndex;
  final SingleTab tab;

  ReloadMessagesState(
    this.tab, {
    this.highlightedMessageIndex,
  });

  @override
  List<Object?> get props => [tab];
}
