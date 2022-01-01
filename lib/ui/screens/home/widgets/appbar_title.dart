import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/top_states.dart';

class AppBarTitle extends StatelessWidget {
  final HomeBloc bloc;
  const AppBarTitle(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, cur) => cur is AppBarDataState,
      builder: (context, state) {
        if (state is AppBarDataState) {
          return Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.appName.isNotEmpty ? state.appName : 'Unknown'),
                  Text(
                    state.ip.isNotEmpty ? state.ip : 'Ip not set',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(width: 5.w),
              ScaleTap(
                onPressed: () {
                  bloc.add(ShowInputIpDialogEvent());
                },
                child: const Icon(
                  Icons.edit,
                ),
              ),
            ],
          );
        }
        return const Text('Not Loaded yet');
      },
    );
  }
}
