import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/body_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';

class LogsList extends StatefulWidget {
  const LogsList({Key? key}) : super(key: key);

  @override
  State<LogsList> createState() => _LogsListState();
}

class _LogsListState extends State<LogsList> {
  late HomeBloc bloc;

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, current) => current is ReloadMessagesState,
      builder: (context, state) {
        return StreamBuilder<List<FilteredLog>>(
            stream: bloc.observeLogs,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Logs Detected',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
              List<FilteredLog> logs = snapshot.data!;
              return ListView.builder(
                reverse: true,
                itemCount: logs.length,
                itemBuilder: (_, index) {
                  return _LogItem(log: logs[index]);
                },
              );
            });
      },
    );
  }
}

class _LogItem extends StatelessWidget {
  final FilteredLog log;

  const _LogItem({
    Key? key,
    required this.log,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(
              log.logMessage.logLevel.color,
            ),
          ),
          bottom: BorderSide(
            color: Color(
              log.logMessage.logLevel.color,
            ),
          ),
          left: BorderSide(
            color: Color(
              log.logMessage.logLevel.color,
            ),
          ),
        ),
      ),
      child: Text(
        log.logMessage.message,
        style: TextStyle(
          color: Color(log.logMessage.logLevel.color),
        ),
      ),
    );
  }
}
