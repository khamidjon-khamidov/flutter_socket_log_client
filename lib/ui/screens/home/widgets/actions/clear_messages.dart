import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/home_event.dart';

class ClearMessagesAction extends StatelessWidget {
  final HomeBloc bloc;
  const ClearMessagesAction(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      child: const Icon(Icons.delete),
      onPressed: () => bloc.add(ClearMessagesEvent()),
    );
  }
}
