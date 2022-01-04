import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';

import 'home_state.dart';

class BottomState extends HomeState {
  final SingleTab tab;

  BottomState({
    required this.tab,
  });

  @override
  List<Object?> get props => [tab];
}
