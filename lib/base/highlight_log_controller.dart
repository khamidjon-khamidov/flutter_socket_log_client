import 'dart:collection';

import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

class HighlightLogController {
  final BehaviorSubject<int?> _highlightedIndexSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<int?> _highlightedIdSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<UserMessage> _errorMessageSubject = BehaviorSubject();
  final BehaviorSubject<int> _searchMatchedLogsCountSubject = BehaviorSubject.seeded(0);

  // map highlighted message indexes
  // HashMap<tab.id, highlightedMessage>
  HashMap<int, int?> highlightedIndexes = HashMap();

  // <tab id, list of all search matched logs>
  HashMap<int, List<int>?> allMatchedIndexes = HashMap();

  int _currentTabId = 0;

  Stream<UserMessage> get observeErrorMessages => _errorMessageSubject.stream;

  Stream<int?> get observeHighlightedLogIndex => _highlightedIndexSubject.stream;
  Stream<int?> get observeHighlightedLogId => _highlightedIdSubject.stream;

  Stream<int?> get observeSearchMatchedCount => _searchMatchedLogsCountSubject.stream;

  int? getMatchesCount(int tabId) => allMatchedIndexes[tabId]?.length;

  int? getHighlightedMatchId(int tabId) => highlightedIndexes[tabId];

  void setAllMatchedIndexes(int tabId, List<int>? indexes) {
    allMatchedIndexes[tabId] = indexes;
    if (tabId == _currentTabId) {
      _searchMatchedLogsCountSubject.add(indexes?.length ?? 0);
    }
  }

  void setNewTab(int tabId) {
    _currentTabId = tabId;
    _searchMatchedLogsCountSubject.add(allMatchedIndexes[tabId]?.length ?? 0);
  }

  void setIndex(int tabId, int? index) {
    highlightedIndexes[tabId] = index;
    if(index!=null) {
      List<int> matches = allMatchedIndexes[tabId]!;
      _highlightedIndexSubject.add(index);
      _highlightedIdSubject.add(matches.length - matches.indexOf(index) - 1);
    }
  }

  void goToNextIndex(int tabId) {
    List<int>? indexes = allMatchedIndexes[tabId];

    if (indexes == null) {
      _errorMessageSubject
          .add(UserMessage.error('Cannot go to next search. No any matching indexes!'));
      return;
    }

    print('assigning index: ${indexes[0]}');
    int current = highlightedIndexes[tabId] ?? indexes[0];

    int? foundIndex = findCurrentIndex(current, indexes, 0, indexes.length - 1);
    if (foundIndex == null) {
      _errorMessageSubject
          .add(UserMessage.error('Cannot go to next search. Matching index not found!'));
      return;
    }

    int resultingIndex = (foundIndex + indexes.length + 1) % indexes.length;

    highlightedIndexes[tabId] = indexes[resultingIndex];
    _highlightedIndexSubject.add(indexes[resultingIndex]);
    _highlightedIdSubject.add(indexes.length - resultingIndex - 1);
  }

  void goToPreviousIndex(int tabId) {
    List<int>? indexes = allMatchedIndexes[tabId];

    if (indexes == null) {
      _errorMessageSubject
          .add(UserMessage.error('Cannot go to previous search. No any matching indexes!'));
      return;
    }

    print('assigning index: ${indexes[0]}');
    int current = highlightedIndexes[tabId] ?? indexes[0];

    int? foundIndex = findCurrentIndex(current, indexes, 0, indexes.length - 1);

    print('Tried find index: indexes: $indexes');
    print('Current: $current, foundIndex: $foundIndex');

    if (foundIndex == null) {
      _errorMessageSubject
          .add(UserMessage.error('Cannot go to previous search. Matching index not found!'));
      return;
    }

    int resultingIndex = (foundIndex + indexes.length - 1) % indexes.length;

    print('Resulting index: $resultingIndex');
    highlightedIndexes[tabId] = indexes[resultingIndex];
    _highlightedIndexSubject.add(indexes[resultingIndex]);
    _highlightedIdSubject.add(indexes.length - resultingIndex - 1);
  }

  void setLastIndex(int tabId) {
    List<int> indexes = allMatchedIndexes[tabId] ?? [];
    int? lastIndex = indexes.isNotEmpty ? indexes.last;
    highlightedIndexes[tabId] = lastIndex;

    _highlightedIndexSubject.add(lastIndex);
    _highlightedIdSubject.add(indexes.length);
  }

  void clearTab(SingleTab tab){
    highlightedIndexes[tab.id] = null;
    allMatchedIndexes[tab.id] = null;
    _highlightedIndexSubject.add(null);
    _highlightedIdSubject.add(null);
    _searchMatchedLogsCountSubject.add(0);
  }

  int? findCurrentIndex(int current, List<int> array, int left, int right) {
    if (left > right) {
      return null;
    }

    int mid = (left + right) ~/ 2;
    if (array[mid] == current) {
      return mid;
    }

    if (array[mid] < current) {
      return findCurrentIndex(current, array, left, mid - 1);
    } else {
      return findCurrentIndex(current, array, mid + 1, right);
    }
  }

  void clear() {
    highlightedIndexes.clear();
    allMatchedIndexes.clear();
    _highlightedIndexSubject.add(null);
  }
}
