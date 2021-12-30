import 'home_state.dart';

class BottomBarState extends HomeState {
  final String filter;
  final bool showOnlySearches;

  BottomBarState(this.filter, this.showOnlySearches);

  @override
  List<Object?> get props => [filter, showOnlySearches];
}
