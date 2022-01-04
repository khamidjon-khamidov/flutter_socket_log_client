import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/ui/screens/components/snackbar.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/actions/add_tab.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/actions/clear_messages.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/actions/connection_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/appbar_title.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/bottom/bottom_filter.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/logs_list.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/tab_list.dart';
import 'package:flutter_socket_log_client/util/dialog_extensions.dart';

import 'bloc/home_state/dialog_states.dart';

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
    // get bloc
    bloc = context.read<HomeBloc>();

    bloc.observeSnackbarMessages.listen((message) {
      AppSnackBar.showViaUserMessage(message, context);
    });
    listenDialogs();
    super.initState();
  }

  void listenDialogs() {
    bloc.stream.listen((HomeState state) {
      if (state is DialogState) {
        state.showFromState(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(bloc),
        actions: [
          AddTabAction(bloc),
          SizedBox(width: 5.w),
          ClearMessagesAction(bloc),
          SizedBox(width: 5.w),
          ConnectionStateAction(bloc),
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
