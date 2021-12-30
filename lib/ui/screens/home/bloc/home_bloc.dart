import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/domain/repsitory/home_repository.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/body_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:flutter_socket_log_client/util/defaults.dart';
import 'package:rxdart/rxdart.dart';

import 'home_state/top_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final BehaviorSubject<UserMessage> _uiMessageSubject = BehaviorSubject();
  Tab selectedTab = defaultTab;

  HomeBloc(this._homeRepository) : super(LoadingState()) {
    handleTopWidgetsBlocEvents();
    handleBodyWidgetsBlocEvents();
    handleInternalBlocEvents();
    observeStates();

    // if ip not set, show dialog
    _homeRepository.appBarData.then((appBarData) {
      if (appBarData.ip.isEmpty) {
        add(ShowInputIpDialogEvent());
      }
    });
  }

  Stream<UserMessage> get observeMessages => MergeStream([
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
      (event, emit) {
        _homeRepository.toggleConnection();
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
          selectedTabId: selectedTabId,
          tabs: await _homeRepository.tabs,
        ),
      );
      if (selectedTabId == editedTab.id) {
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
        selectedTabId = newTab.id;
        emit(
          TabsState(
            selectedTabId: selectedTabId,
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
            selectedTabId: selectedTabId,
            tabs: await _homeRepository.tabs,
          ),
        );

        _homeRepository.setFilter(filter)
        emit(ReloadMessagesState());
      },
      transformer: droppable(),
    );

    // todo add main ui state
    on<TabSelectedEvent>((event, emit) async {
      selectedTabId = event.tab.id;
      emit(EmptyState());
      emit(TabsState(
        selectedTabId: selectedTabId,
        tabs: await _homeRepository.tabs,
      ));
    });

    on<CloseTabEvent>(
      (event, emit) async {
        if (selectedTabId == event.tab.id) {
          selectedTabId = 0;
        }
        emit(EmptyState());
        emit(TabsState(
          selectedTabId: selectedTabId,
          tabs: await _homeRepository.deleteTab(event.tab),
        ));
      },
      transformer: droppable(),
    );
  }

  void handleBodyWidgetsBlocEvents() {}

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
