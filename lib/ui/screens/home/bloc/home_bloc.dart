import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/domain/repsitory/home_repository.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  Settings? _settings;

  HomeBloc(this._homeRepository) : super(LoadingState()) {
    on<SetIpEvent>((event, emit) async {
      // delete all current settings
      _settings = null;
      _homeRepository.clearAll();

      // setNewSettings
    });

    // load settings
  }
}
