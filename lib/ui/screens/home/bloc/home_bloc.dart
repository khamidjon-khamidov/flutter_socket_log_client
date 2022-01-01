import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/domain/repsitory/home_repository.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/bottom_events.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/body_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/bottom_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:flutter_socket_log_client/util/defaults.dart';
import 'package:rxdart/rxdart.dart';

import 'home_event/top_events.dart';
import 'home_state/top_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final BehaviorSubject<UserMessage> _uiMessageSubject = BehaviorSubject();
  Tab selectedTab = defaultTab;

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
        emit(EmptyState());
        emit(ShowInputIpDialogState(
          appName: appBarData.appName,
          ip: appBarData.ip,
        ));
      },
      transformer: droppable(),
    );

    on<ShowAddTabDialogEvent>(
      (event, emit) async {
        if (_homeRepository.allLogLevels == null) {
          _uiMessageSubject
              .add(UserMessage.error('At least one log should be received to add new tab'));
        } else {
          emit(EmptyState());
          emit(ShowAddTabDialogState(
            allLogLevels: _homeRepository.allLogLevels!,
            allLogTags: _homeRepository.allLogTags!,
          ));
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
          emit(EmptyState());
          emit(ShowEditTabDialogState(
            tab: event.tab,
            allLogLevels: _homeRepository.allLogLevels!,
            allLogTags: _homeRepository.allLogTags!,
          ));
        }
      },
      transformer: droppable(),
    );

    on<EditTabEvent>((event, emit) async {
      emit(EmptyState());
      Tab editedTab = await _homeRepository.editTab(
        newTabName: event.newName,
        tab: event.tab,
        logTags: event.selectedTags,
        logLevels: event.selectedLogLevels,
      );

      emit(
        TabsState(
          selectedTabId: selectedTab.id,
          tabs: await _homeRepository.tabs,
        ),
      );
      if (selectedTab.id == editedTab.id) {
        _homeRepository.setFilter(editedTab.filter);
        emit(ReloadMessagesState());
      }
    });

    on<AddNewTabEvent>(
      (event, emit) async {
        emit(EmptyState());
        Tab newTab = await _homeRepository.addTab(
          event.tabName,
          event.selectedLogTags,
          event.selectedLogLevels,
        );
        selectedTab = newTab;
        emit(
          TabsState(
            selectedTabId: selectedTab.id,
            tabs: await _homeRepository.tabs,
          ),
        );

        // send new message with
        // current tab to ui
        _homeRepository.setFilter(newTab.filter);
        emit(ReloadMessagesState());
      },
      transformer: droppable(),
    );

    // todo add main ui state
    on<GetTabsEvent>(
      (event, emit) async {
        emit(EmptyState());
        emit(
          TabsState(
            selectedTabId: selectedTab.id,
            tabs: await _homeRepository.tabs,
          ),
        );

        _homeRepository.setFilter(selectedTab.filter);
        emit(ReloadMessagesState());
        emit(BottomState(selectedTab));
      },
      transformer: droppable(),
    );

    // todo add main ui state
    on<TabSelectedEvent>((event, emit) async {
      selectedTab = event.tab;
      emit(EmptyState());
      emit(
        TabsState(
          selectedTabId: selectedTab.id,
          tabs: await _homeRepository.tabs,
        ),
      );

      _homeRepository.setFilter(selectedTab.filter);
      emit(ReloadMessagesState());
      emit(BottomState(selectedTab));
    });

    on<CloseTabEvent>(
      (event, emit) async {
        if (selectedTab.id == event.tab.id) {
          selectedTab = defaultTab;
        }
        emit(EmptyState());
        emit(TabsState(
          selectedTabId: selectedTab.id,
          tabs: await _homeRepository.deleteTab(event.tab),
        ));

        _homeRepository.setFilter(selectedTab.filter);
        emit(ReloadMessagesState());
        emit(BottomState(selectedTab));
      },
      transformer: droppable(),
    );
  }

  void handleBottomWidgetsBlocEvents() {
    on<ShowOnlySearchesEvent>((event, emit) async {
      Tab tab =
          await _homeRepository.updateShowOnlySearchesInTab(event.showOnlySearches, event.tab);

      _homeRepository.setFilter(tab.filter);
      emit(ReloadMessagesState());
    });

    on<SearchEvent>(
      (event, emit) async {
        await Future.delayed(const Duration(seconds: 500));
        Tab tab = await _homeRepository.updateSearchFilterInTab(event.search, event.tab);
        selectedTab = tab;

        _homeRepository.setFilter(tab.filter);
        emit(ReloadMessagesState());
        emit(BottomState(selectedTab));
      },
      transformer: restartable(),
    );
  }

  void handleInternalBlocEvents() {
    on<ConnectionToggledEvent>((event, emit) {
      emit(EmptyState());
      emit(LogConnectionState(event.isConnected));
    });

    on<AppBarDataReceivedEvent>((event, emit) {
      emit(EmptyState());
      emit(
        AppBarDataState(
          appName: event.appName,
          ip: event.ip,
        ),
      );
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
}
