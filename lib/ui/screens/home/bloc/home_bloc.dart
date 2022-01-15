import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/models/connection_state.dart';
import 'package:flutter_socket_log_client/domain/models/move_highlighted_message_type.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/filtered_log.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';
import 'package:flutter_socket_log_client/domain/repository/home_repository.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/bottom_events.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/body_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/bottom_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

import 'home_event/top_events.dart';
import 'home_state/dialog_states.dart';
import 'home_state/top_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final BehaviorSubject<UserMessage> _uiMessageSubject = BehaviorSubject();

  HomeBloc(this._homeRepository) : super(LoadingState()) {
    handleTabEvents();
    handleBottomWidgetsBlocEvents();
    handleDialogEvents();
    handleTopBarEvents();
    observeStates();

    // if ip not set, show dialog
    _homeRepository.appBarData.then((appBarData) {
      if (appBarData.ip.isEmpty) {
        add(ShowInputIpDialogEvent());
      }
    });
  }

  SingleTab get _selectedTab => _homeRepository.selectedTab;

  Stream<List<FilteredLog>> get observeLogs => _homeRepository.observeFilteredLogs;

  Stream<int?> get observeMatchedLogsCount =>
      _homeRepository.highlightLogController.observeSearchMatchedCount;

  Stream<int?> get observeHighlightedIndex =>
      _homeRepository.highlightLogController.observeHighlightedLogIndex;

  Stream<int?> get observeHighlightedLogId =>
      _homeRepository.highlightLogController.observeHighlightedLogId;

  Stream<UserMessage> get observeSnackbarMessages => MergeStream([
        _uiMessageSubject.stream,
        _homeRepository.observeSnackbarMessages,
        _homeRepository.highlightLogController.observeErrorMessages,
      ]);

  Stream<SocketConnectionState> get observeSocketConnectionState =>
      _homeRepository.observeSocketConnectionState;

  void observeStates() {
    _homeRepository.observeAppBarData.listen((appBarData) {
      add(AppBarDataReceivedEvent(appBarData.appName, appBarData.ip));
    });
  }

  void handleDialogEvents() {
    on<ShowInputIpDialogEvent>(
      (event, emit) async {
        AppBarData appBarData = await _homeRepository.appBarData;
        emitNewState(
            ShowInputIpDialogState(
              appName: appBarData.appName,
              ip: appBarData.ip,
            ),
            emit);
      },
      transformer: droppable(),
    );

    on<ShowAddTabDialogEvent>(
      (event, emit) async {
        if (_homeRepository.allLogLevels == null) {
          _uiMessageSubject
              .add(UserMessage.error('At least one log should be received to add new tab'));
        } else {
          emitNewState(
              ShowAddTabDialogState(
                allLogLevels: _homeRepository.allLogLevels!,
                allLogTags: _homeRepository.allLogTags!,
              ),
              emit);
        }
      },
      transformer: droppable(),
    );

    on<ShowEditTabDialogEvent>(
      (event, emit) async {
        if (_homeRepository.allLogLevels == null) {
          _uiMessageSubject
              .add(UserMessage.error('At least one log should be received to add new tab'));
        } else {
          emitNewState(
              ShowEditTabDialogState(
                tab: event.tab,
                allLogLevels: _homeRepository.allLogLevels!,
                allLogTags: _homeRepository.allLogTags!,
              ),
              emit);
        }
      },
      transformer: droppable(),
    );
  }

  void handleTopBarEvents() {
    on<UpdateAppSettingsEvent>((event, emit) async {
      await _homeRepository.updateAppNameAndIp(
        event.ip,
        event.appName,
        event.shouldClearSettings,
      );
    });

    on<ToggleConnectionStateEvent>(
      (event, emit) async {
        await _homeRepository.toggleConnection();
      },
      transformer: droppable(),
    );

    on<ClearMessagesEvent>((event, emit) async {
      _homeRepository.clearMessages();
      reloadMessagesWithBottomState(false, emit);
    });

    on<AppBarDataReceivedEvent>((event, emit) {
      emitNewState(AppBarDataState(appName: event.appName, ip: event.ip), emit);
    });
  }

  void handleTabEvents() {
    on<EditTabEvent>((event, emit) async {
      SingleTab editedTab = await _homeRepository.editTab(
        newTabName: event.newName,
        tab: event.tab,
        logTags: event.selectedTags,
        logLevels: event.selectedLogLevels,
      );

      emitNewState(
        TabsState(
          selectedTabId: _selectedTab.id,
          tabs: (await _homeRepository.tabs).toList(),
        ),
        emit,
      );
      if (_selectedTab.id == editedTab.id) {
        reloadMessagesWithBottomState(false, emit);
      }
    });

    on<AddNewTabEvent>(
      (event, emit) async {
        SingleTab newTab = await _homeRepository.addTab(
          event.tabName,
          event.selectedLogTags,
          event.selectedLogLevels,
        );
        await goToTab(newTab, emit);
      },
      transformer: droppable(),
    );

    on<GetTabsEvent>(
      (event, emit) async {
        emitNewState(
            TabsState(
              selectedTabId: _selectedTab.id,
              tabs: (await _homeRepository.tabs).toList(),
            ),
            emit);

        reloadMessagesWithBottomState(true, emit);
      },
      transformer: droppable(),
    );

    on<TabSelectedEvent>((event, emit) async {
      await goToTab(event.tab, emit);
    });

    on<CloseTabEvent>(
      (event, emit) async {
        if (_selectedTab.id == event.tab.id) {
          _homeRepository.setSelectedTab();
        }
        emitNewState(
          TabsState(
            selectedTabId: _selectedTab.id,
            tabs: (await _homeRepository.deleteTab(event.tab)).toList(),
          ),
          emit,
        );

        reloadMessagesWithBottomState(true, emit);
      },
      transformer: droppable(),
    );
  }

  void handleBottomWidgetsBlocEvents() {
    on<ShowOnlySearchesEvent>((event, emit) async {
      await _homeRepository.updateShowOnlySearchesInTab(event.showOnlySearches, event.tab);

      reloadMessagesWithBottomState(true, emit);
    });

    on<SearchEvent>(
      (event, emit) async {
        await Future.delayed(const Duration(milliseconds: 300));
        _homeRepository.highlightLogController.clearTab(event.tab);
        await _homeRepository.updateSearchFilterInTab(event.search, event.tab);

        reloadMessagesWithBottomState(true, emit);
      },
      transformer: restartable(),
    );

    on<ChangeHighlightedMessageEvent>((event, emit) {
      if (event.changeHighlightedMessageType is MoveToPrevious) {
        _homeRepository.highlightLogController.goToPreviousIndex(_homeRepository.selectedTab.id);
      } else if (event.changeHighlightedMessageType is MoveToNext) {
        _homeRepository.highlightLogController.goToNextIndex(_homeRepository.selectedTab.id);
      } else if (event.changeHighlightedMessageType is MoveToMessage) {
        _homeRepository.highlightLogController.setIndex(
          _homeRepository.selectedTab.id,
          (event.changeHighlightedMessageType as MoveToMessage).index,
        );
      }
    });

    on<ClearHighlightingEvent>((event, emit) async {
      _homeRepository.highlightLogController.clearTab(_selectedTab);
    });
  }

  Future<void> goToTab(SingleTab tab, Emitter<HomeState> emitter) async {
    _homeRepository.setSelectedTab(tab: tab);
    _homeRepository.highlightLogController.setNewTab(tab.id);
    emitNewState(
      TabsState(
        selectedTabId: _selectedTab.id,
        tabs: (await _homeRepository.tabs).toList(),
      ),
      emitter,
    );

    reloadMessagesWithBottomState(true, emitter);
  }

  void reloadMessagesWithBottomState(bool reloadBottomState, Emitter<HomeState> emitter) {
    emitter(ReloadMessagesState(_selectedTab));
    if (reloadBottomState) {
      emitter(BottomState(tab: _selectedTab));
    }
  }

  void emitNewState(HomeState state, Emitter<HomeState> emitter) {
    emitter(EmptyState());
    emitter(state);
  }
}
