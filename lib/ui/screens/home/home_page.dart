import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/ui/screens/components/snackbar.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';

import 'bloc/home_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeBloc bloc;
  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    bloc.observeMessages.listen((message) {
      switch (message.messageType) {
        case MessageType.error:
          AppSnackBar.showError(
            ScaffoldMessenger.of(context),
            title: message.message,
          );
          return;
        case MessageType.warning:
          AppSnackBar.showWarning(
            ScaffoldMessenger.of(context),
            title: message.message,
          );
          return;
        case MessageType.success:
          AppSnackBar.showSuccess(
            ScaffoldMessenger.of(context),
            title: message.message,
          );
          return;
        case MessageType.info:
          AppSnackBar.showInfo(
            ScaffoldMessenger.of(context),
            title: message.message,
          );
          return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (prev, cur) => cur is AppBarDataState,
          builder: (context, state) {
            if (state is AppBarDataState) {
              return Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.appName),
                      Text(
                        state.ip,
                        style: TextStyle(fontSize: 6.sp),
                      ),
                    ],
                  ),
                  SizedBox(width: 5.w),
                  ScaleTap(
                    onPressed: () {},
                    child: const Icon(
                      Icons.edit,
                    ),
                  ),
                ],
              );
            }
            return const Text('Not Loaded yet');
          },
        ),
        actions: [
          // add new tab
          ScaleTap(
            onPressed: () {},
            child: const Icon(
              Icons.add,
            ),
          ),
          SizedBox(width: 5.w),
          // log recorder, connection state
          BlocBuilder<HomeBloc, HomeState>(
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
                    Text(
                      state.isConnected ? 'Logging' : 'Not Logging',
                      style: TextStyle(
                        fontSize: 6.sp,
                      ),
                    ),
                  ],
                );
              }

              return Container();
            },
          ),
          SizedBox(width: 5.w),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (prev, current) => current is! EmptyState,
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}

///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
