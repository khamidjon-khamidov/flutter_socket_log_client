import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/models/offline/filtered_log.dart';
import 'package:flutter_socket_log_client/domain/models/offline/tab.dart';
import 'package:flutter_socket_log_client/domain/repsitory/home_repository.dart';
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
  SingleTab selectedTab = SingleTab.defaultTab();

  HomeBloc(this._homeRepository) : super(LoadingState()) {
    handleTopWidgetsBlocEvents();
    handleBottomWidgetsBlocEvents();
    handleInternalBlocEvents();
    observeStates();

    // if ip not set, show dialog
    _homeRepository.appBarData.then((appBarData) {
      if (appBarData.ip.isEmpty) {
        add(ShowInputIpDialogEvent());
      }
    });
  }

  Stream<UserMessage> get observeSnackbarMessages => MergeStream([
        _uiMessageSubject.stream,
        _homeRepository.observeSnackbarMessages,
      ]);

  void handleTopWidgetsBlocEvents() {
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

    on<EditTabEvent>((event, emit) async {
      SingleTab editedTab = await _homeRepository.editTab(
        newTabName: event.newName,
        tab: event.tab,
        logTags: event.selectedTags,
        logLevels: event.selectedLogLevels,
      );

      emitNewState(
          TabsState(
            selectedTabId: selectedTab.id,
            tabs: (await _homeRepository.tabs).toList(),
          ),
          emit);
      if (selectedTab.id == editedTab.id) {
        _homeRepository.setFilter(editedTab.filter);
        emit(ReloadMessagesState(selectedTab));
      }
    });

    on<AddNewTabEvent>(
      (event, emit) async {
        SingleTab newTab = await _homeRepository.addTab(
          event.tabName,
          event.selectedLogTags,
          event.selectedLogLevels,
        );
        selectedTab = newTab;
        emitNewState(
            TabsState(
              selectedTabId: selectedTab.id,
              tabs: (await _homeRepository.tabs).toList(),
            ),
            emit);

        // send new message with
        // current tab to ui
        _homeRepository.setFilter(newTab.filter);
        emit(ReloadMessagesState(selectedTab));
      },
      transformer: droppable(),
    );

    // todo add main ui state
    on<GetTabsEvent>(
      (event, emit) async {
        emitNewState(
            TabsState(
              selectedTabId: selectedTab.id,
              tabs: (await _homeRepository.tabs).toList(),
            ),
            emit);

        _homeRepository.setFilter(selectedTab.filter);
        emit(ReloadMessagesState(selectedTab));
        emit(BottomState(selectedTab));
      },
      transformer: droppable(),
    );

    on<TabSelectedEvent>((event, emit) async {
      selectedTab = event.tab;
      emitNewState(
        TabsState(
          selectedTabId: selectedTab.id,
          tabs: (await _homeRepository.tabs).toList(),
        ),
        emit,
      );

      _homeRepository.setFilter(selectedTab.filter);
      emit(ReloadMessagesState(selectedTab));
      emit(BottomState(selectedTab));
    });

    on<CloseTabEvent>(
      (event, emit) async {
        if (selectedTab.id == event.tab.id) {
          selectedTab = (await _homeRepository.defaultTab);
        }
        emitNewState(
            TabsState(
              selectedTabId: (selectedTab).id,
              tabs: (await _homeRepository.deleteTab(event.tab)).toList(),
            ),
            emit);

        _homeRepository.setFilter(selectedTab.filter);
        emit(ReloadMessagesState(selectedTab));
        emit(BottomState(selectedTab));
      },
      transformer: droppable(),
    );

    on<ClearMessagesEvent>((event, emit) async {
      _homeRepository.clearMessages();
      emit(ReloadMessagesState(selectedTab));
    });
  }

  void handleBottomWidgetsBlocEvents() {
    on<ShowOnlySearchesEvent>((event, emit) async {
      SingleTab tab =
          await _homeRepository.updateShowOnlySearchesInTab(event.showOnlySearches, event.tab);

      _homeRepository.setFilter(tab.filter);
      emit(ReloadMessagesState(selectedTab));
      emit(BottomState(selectedTab));
    });

    on<SearchEvent>(
      (event, emit) async {
        await Future.delayed(const Duration(milliseconds: 500));
        SingleTab tab = await _homeRepository.updateSearchFilterInTab(event.search, event.tab);
        selectedTab = tab;

        _homeRepository.setFilter(tab.filter);
        emit(ReloadMessagesState(selectedTab));
        emit(BottomState(selectedTab));
      },
      transformer: restartable(),
    );
  }

  void handleInternalBlocEvents() {
    on<ConnectionToggledEvent>((event, emit) {
      emitNewState(LogConnectionState(event.isConnected), emit);
    });

    on<AppBarDataReceivedEvent>((event, emit) {
      emitNewState(AppBarDataState(appName: event.appName, ip: event.ip), emit);
    });
  }

  void observeStates() {
    _homeRepository.observeAppBarData.listen((appBarData) {
      add(AppBarDataReceivedEvent(appBarData.appName, appBarData.ip));
    });

    _homeRepository.observeSocketConnectionState.listen((bool isConnected) {
      add(ConnectionToggledEvent(isConnected));
    });
  }

  Stream<List<FilteredLog>> get observeLogs => _homeRepository.observeFilteredLogs;

  void emitNewState(HomeState state, Emitter<HomeState> emitter) {
    emitter(EmptyState());
    emitter(state);
  }
}
