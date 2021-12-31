import 'home_state.dart';

class ShowOnlySearchesState extends HomeState {
  final bool showOnlySearches;

  ShowOnlySearchesState(this.showOnlySearches);

  @override
  List<Object?> get props => [showOnlySearches];
}

class SearchState extends HomeState {
  final String search;

  SearchState(this.search);

  @override
  List<Object?> get props => [search];
}
