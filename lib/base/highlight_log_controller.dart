import 'dart:collection';

import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

class HighlightLogController {
  // map highlighted message indexes
  // HashMap<tab.id, highlightedMessage>
  HashMap<int, int?> highlightedIndexes = HashMap();

  // <tab id, list of all search matched logs>
  HashMap<int, List<int>?> allMatchedIndexes = HashMap();

  final BehaviorSubject<int?> _highlightedIndexSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<UserMessage> userMessageSubject = BehaviorSubject();

  int? getMatchesCount(int tabId) => allMatchedIndexes[tabId]?.length;

  int? getHighlightedMatchId(int tabId) => highlightedIndexes[tabId];

  void setAllMatchedIndexes(int tabId, List<int>? indexes) => allMatchedIndexes[tabId] = indexes;

  void setIndex(int tabId, int? index) {
    highlightedIndexes[tabId] = index;
    _highlightedIndexSubject.add(index);
  }

  void goToNextIndex(int tabId, int current) {
    List<int>? indexes = allMatchedIndexes[tabId];

    if (indexes == null) {
      userMessageSubject
          .add(UserMessage.error('Cannot go to next search. No any matching indexes!'));
      return;
    }

    int? foundIndex = findCurrentIndex(current, indexes, 0, indexes.length - 1);
    if (foundIndex == null) {
      userMessageSubject
          .add(UserMessage.error('Cannot go to next search. Matching index not found!'));
      return;
    }

    int resultingIndex = (foundIndex + indexes.length + 1) % indexes.length;

    highlightedIndexes[tabId] = resultingIndex;
    _highlightedIndexSubject.add(resultingIndex);
  }

  void getPreviousIndex(int tabId, int current) {
    List<int>? indexes = allMatchedIndexes[tabId];

    if (indexes == null) {
      userMessageSubject
          .add(UserMessage.error('Cannot go to previous search. No any matching indexes!'));
      return;
    }

    int? foundIndex = findCurrentIndex(current, indexes, 0, indexes.length - 1);
    if (foundIndex == null) {
      userMessageSubject
          .add(UserMessage.error('Cannot go to previous search. Matching index not found!'));
      return;
    }

    int resultingIndex = (foundIndex + indexes.length - 1) % indexes.length;

    highlightedIndexes[tabId] = resultingIndex;
    _highlightedIndexSubject.add(resultingIndex);
  }

  void setLastIndex(int tabId) {
    int? lastIndex = allMatchedIndexes[tabId]?.last;
    highlightedIndexes[tabId] = lastIndex;

    _highlightedIndexSubject.add(lastIndex);
  }

  int? findCurrentIndex(int current, List<int> array, int left, int right) {
    if (left == right) {
      print(
          'findCurrentIndex. Found match: current: $current, index: $left, value: ${array[left]}');
      return left;
    }
    if (left > right) {
      return null;
    }

    int mid = (left + right) ~/ 2;

    if (array[mid] > current) {
      return findCurrentIndex(current, array, left, mid);
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
