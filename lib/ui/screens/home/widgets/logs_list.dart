import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/body_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';
import 'package:intl/intl.dart';

DateFormat _outputFormat = DateFormat('MM/dd/yyyy hh:mm a');

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
                physics: const BouncingScrollPhysics(),
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
    Color logLevelColor = Color(
      log.logMessage.logLevel.color,
    );
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: logLevelColor,
          ),
          bottom: BorderSide(
            color: logLevelColor,
          ),
          left: BorderSide(
            color: logLevelColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: logLevelColor),
                    right: BorderSide(color: logLevelColor),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      IconData(
                        log.logMessage.logLevel.iconData,
                        fontFamily: 'MaterialIcons',
                      ),
                      size: 24,
                      color: logLevelColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      log.logMessage.logLevel.name,
                      style: TextStyle(color: logLevelColor, fontSize: 16),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Time: ${_outputFormat.format(DateTime.fromMillisecondsSinceEpoch(log.logMessage.timestamp.toInt()))}',
                      style: TextStyle(color: logLevelColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: logLevelColor),
                    right: BorderSide(color: logLevelColor),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: log.logMessage.logTags.map((e) {
                    return Icon(
                      IconData(e.iconData, fontFamily: 'MaterialIcons'),
                      color: Color(e.color),
                      size: 24,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              log.logMessage.message,
              style: TextStyle(
                color: logLevelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
