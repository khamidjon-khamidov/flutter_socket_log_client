import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/top_events.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';

class ConnectionStateAction extends StatelessWidget {
  final HomeBloc bloc;
  const ConnectionStateAction(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, cur) => cur is LogConnectionState, // cur is LogConnectionState,
      builder: (context, state) {
        if (state is LogConnectionState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTap(
                onPressed: () {
                  bloc.add(ToggleConnectionStateEvent());
                },
                child: Icon(
                  Icons.circle,
                  color: state.isConnected ? Colors.green : Colors.grey,
                ),
              ),
              Text(state.isConnected ? 'Logging' : 'Not Logging'),
            ],
          );
        }
        return Container();
      },
    );
  }
}
