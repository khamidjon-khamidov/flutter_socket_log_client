import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/home_event.dart';

class AddTabAction extends StatelessWidget {
  final HomeBloc bloc;
  const AddTabAction(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onPressed: () {
        bloc.add(ShowAddTabDialogEvent());
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }
}
