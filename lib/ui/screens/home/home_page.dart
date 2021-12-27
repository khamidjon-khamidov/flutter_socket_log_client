import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/ui/screens/components/snackbar.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (prev, current) => current is! EmptyState,
        builder: (context, state) {
          if (state is LoadingState) {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
          return HomeView();
        });
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    context.read<HomeBloc>().observeMessages.listen((message) {
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
          buildWhen: (prev, cur) => cur is AppBarDataState || cur is LoadingState,
          builder: (context, state) {
            if (state is AppBarDataState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.appName),
                  Text(
                    state.ip,
                    style: TextStyle(fontSize: 6.sp),
                  ),
                ],
              );
            }
            return const Text('Not Loaded yet');
          },
        ),
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
