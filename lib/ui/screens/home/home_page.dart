import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/ui/screens/components/snackbar.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/bottom_filter.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/dialogs/add_tab_dialog.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/dialogs/edit_tab_dialog.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/dialogs/input_ip_dialog.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/logs_list.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/tab_list.dart';

import 'bloc/home_event/home_event.dart';
import 'bloc/home_event/top_events.dart';
import 'bloc/home_state/top_states.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeView();
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
    bloc.observeSnackbarMessages.listen((message) {
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
    listenStates();
    super.initState();
  }

  void listenStates() {
    bloc.stream.listen((HomeState state) {
      if (state is ShowInputIpDialogState) {
        showDialog(
          context: context,
          builder: (context) => InputIpDialog(
            ip: state.ip,
            appName: state.appName,
          ),
        );
      } else if (state is ShowAddTabDialogState) {
        showDialog(
          context: context,
          builder: (context) => AddTabDialog(
            allLogLevels: HashSet.from(state.allLogLevels),
            allLogTags: HashSet.from(state.allLogTags),
            selectedLogLevels: HashSet(),
            selectedLogTags: HashSet(),
          ),
        );
      } else if (state is ShowEditTabDialogState) {
        showDialog(
          context: context,
          builder: (context) => EditTabDialog(
            tab: state.tab,
            allLogLevels: HashSet.from(state.allLogLevels),
            allLogTags: HashSet.from(state.allLogTags),
            selectedLogLevels: HashSet.of(state.tab.filter.logLevels),
            selectedLogTags: HashSet.of(state.tab.filter.tags),
          ),
        );
      }
    });
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
        ),
        actions: [
          // add new tab
          ScaleTap(
            onPressed: () {
              bloc.add(ShowAddTabDialogEvent());
            },
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
                    Text(state.isConnected ? 'Logging' : 'Not Logging'),
                  ],
                );
              }

              return Container();
            },
          ),
          SizedBox(width: 5.w),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TabList(),
          Expanded(child: LogsList()),
          BottomFilter(),
        ],
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
