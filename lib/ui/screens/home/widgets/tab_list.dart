import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state.dart';
import 'package:provider/src/provider.dart';

class TabList extends StatefulWidget {
  const TabList({Key? key}) : super(key: key);

  @override
  State<TabList> createState() => _TabListState();
}

class _TabListState extends State<TabList> {
  late HomeBloc bloc;

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    bloc.add(GetTabsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      buildWhen: (_, current) => current is TabsState,
      builder: (c, state) {
        state as TabsState;
        return ListView(
          children: state.tabs.map((e) => SizedBox()).toList(),
        );
      },
    );
  }
}
