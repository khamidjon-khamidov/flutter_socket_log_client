import 'package:flutter_socket_log_client/domain/models/offline/tab.dart';

import 'home_state.dart';

class ReloadMessagesState extends HomeState {
  final SingleTab tab;

  ReloadMessagesState(this.tab);

  @override
  List<Object?> get props => [tab];
}
