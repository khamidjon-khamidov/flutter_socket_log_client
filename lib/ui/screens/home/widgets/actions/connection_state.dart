import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_socket_log_client/domain/models/connection_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/top_events.dart';

class ConnectionStateAction extends StatelessWidget {
  final HomeBloc bloc;
  const ConnectionStateAction(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SocketConnectionState>(
      stream: bloc.observeSocketConnectionState,
      builder: (context, snapshot) {
        SocketConnectionState state = snapshot.data ?? SocketConnectionState.disconnected;

        if (state.isLoading) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
            ],
          );
        }

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
      },
    );
  }
}
