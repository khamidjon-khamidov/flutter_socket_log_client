import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

import 'home_state.dart';

class ShowOnlySearchesState extends HomeState {
  final bool showOnlySearches;

  ShowOnlySearchesState(this.showOnlySearches);

  @override
  List<Object?> get props => [showOnlySearches];
}

class BottomState extends HomeState {
  final Tab tab;

  BottomState(this.tab);

  @override
  List<Object?> get props => [tab];
}
