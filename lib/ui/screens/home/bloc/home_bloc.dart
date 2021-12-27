import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/repsitory/home_repository.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final BehaviorSubject<UIMessage> _uiMessageSubject = BehaviorSubject();

  HomeBloc(this._homeRepository) : super(LoadingState()) {
    handleOutsideBlocEvents();
    handleInternalBlocEvents();
    observeStates();
  }

  Stream<UIMessage> get observeMessages => _uiMessageSubject.stream;

  void handleOutsideBlocEvents() {
    on<SetIpEvent>((event, emit) async {
      await _homeRepository.setNewIp(event.ip);
    });

    on<ToggleConnectionStateEvent>((event, emit) {
      _homeRepository.toggleConnection();
    });
  }

  void handleInternalBlocEvents() {
    on<ConnectionToggledEvent>((event, emit) {
      emit(EmptyState());
      emit(ConnectionState(event.isConnected));
    });

    on<IpReceivedEvent>((event, emit) {
      emit(EmptyState());
      emit(IpState(
        ip: event.ip,
      ));
    });

    on<AppNameReceivedEvent>((event, emit) {
      emit(EmptyState());
      emit(AppNameState(
        appName: event.appName,
      ));
    });
  }

  void observeStates() {
    _homeRepository.observeIp.listen((ip) {
      add(IpReceivedEvent(ip));
    });

    _homeRepository.observeAppName.listen((appName) {
      add(AppNameReceivedEvent(appName));
    });

    _homeRepository.observeSocketConnectionState.listen((bool isConnected) {
      add(ConnectionToggledEvent(isConnected));
    });
  }
}
