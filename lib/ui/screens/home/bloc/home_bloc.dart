import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/repsitory/home_repository.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final BehaviorSubject<UserMessage> _uiMessageSubject = BehaviorSubject();

  HomeBloc(this._homeRepository) : super(LoadingState()) {
    handleOutsideBlocEvents();
    handleInternalBlocEvents();
    observeStates();
  }

  Stream<UserMessage> get observeMessages => MergeStream([
        _uiMessageSubject.stream,
        _homeRepository.observeUserMessages,
      ]);

  void handleOutsideBlocEvents() {
    on<SetIpEvent>((event, emit) async {
      await _homeRepository.setNewIp(event.ip);
    });

    on<ToggleConnectionStateEvent>(
      (event, emit) {
        _homeRepository.toggleConnection();
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
      print('adding log ConnectionToggledEvent');
      add(ConnectionToggledEvent(isConnected));
    });
  }
}
