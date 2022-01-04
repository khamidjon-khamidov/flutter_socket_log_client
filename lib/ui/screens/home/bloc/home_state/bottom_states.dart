import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';

import 'home_state.dart';

class BottomState extends HomeState {
  final SingleTab tab;
  final int? highlightedMessageIndex;
  final int? matchedLogsCount;

  BottomState({
    required this.tab,
    this.highlightedMessageIndex,
    this.matchedLogsCount,
  });

  @override
  List<Object?> get props => [tab];
}
