import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/repsitory/home_repository.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc(this._homeRepository) : super(LoadingState()) {
    handleOutsideBlocEvents();
    handleInternalBlocEvents();

    _homeRepository.observeSettings.listen((settings) {
      add(SettingsEvent(settings));
    });

    _homeRepository.observeSocketConnectionState.listen((bool isConnected) {
      add(ConnectionToggledEvent(isConnected));
    });
  }

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

    on<SettingsEvent>((event, emit) {
      var settings = event.settings;
      emit(EmptyState());
      emit(AppBarState(
        appName: settings.appName,
        ip: settings.ip,
      ));
    });
  }
}
