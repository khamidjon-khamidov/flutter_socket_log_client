import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/domain/repsitory/home_repository.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final BehaviorSubject<UserMessage> _uiMessageSubject = BehaviorSubject();
  int selectedTabId = 0;

  HomeBloc(this._homeRepository) : super(LoadingState()) {
    handleOutsideBlocEvents();
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
        _homeRepository.observeUserMessages,
      ]);

  void handleOutsideBlocEvents() {
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
        // fake dialogs for testing
        // emit(EmptyState());
        // emit(ShowAddTabDialogState(
        //   allLogLevels: fakeLogLevels,
        //   allLogTags: fakeLogTags,
        // ));
        // return;

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
        // fake dialogs for testing
        // emit(EmptyState());
        // emit(ShowEditTabDialogState(
        //   tab: event.tab,
        //   allLogLevels: fakeLogLevels,
        //   allLogTags: fakeLogTags,
        // ));
        // return;

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

    on<EditTabEvent>((event, emit) async {
      emit(EmptyState());
      List<Tab> tabs = await _homeRepository.editTab(
        newTabName: event.newName,
        tab: event.tab,
        logTags: event.selectedTags,
        logLevels: event.selectedLogLevels,
      );

      emit(
        TabsState(
          selectedTabId: selectedTabId,
          tabs: tabs,
        ),
      );
    });

    on<AddNewTabEvent>(
      (event, emit) async {
        emit(EmptyState());
        List<Tab> tabs = await _homeRepository.saveTab(
          event.tabName,
          event.selectedLogTags,
          event.selectedLogLevels,
        );
        selectedTabId = tabs.last.id;
        emit(
          TabsState(
            selectedTabId: selectedTabId,
            tabs: tabs,
          ),
        );
      },
      transformer: droppable(),
    );

    // todo add main ui state
    on<GetTabsEvent>(
      (event, emit) async {
        emit(EmptyState());
        emit(TabsState(
          selectedTabId: selectedTabId,
          tabs: await _homeRepository.tabs,
        ));
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
}
