import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_socket_log_client/domain/models/move_highlighted_message_type.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/filtered_log.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/bottom_events.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/body_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

DateFormat _outputFormat = DateFormat('hh:mm:ss a');

class LogsList extends StatefulWidget {
  const LogsList({Key? key}) : super(key: key);

  @override
  State<LogsList> createState() => _LogsListState();
}

class _LogsListState extends State<LogsList> {
  late HomeBloc bloc;
  late AutoScrollController controller;
  final scrollDirection = Axis.vertical;
  int? lastScrolledIndex;

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    super.initState();
    bloc.observeHighlightedIndex.listen((index) {
      lastScrolledIndex = index;
      if (index != null) {
        _scrollToIndex(index);
      }
    });
    controller = AutoScrollController(
        viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }

  Future _scrollToIndex(int index) async {
    await controller.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
    controller.highlight(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, current) => current is ReloadMessagesState,
      builder: (context, state) {
        if (state is! ReloadMessagesState) {
          return const Center(
            child: Text(
              'No Logs Detected',
              style: TextStyle(fontSize: 20),
            ),
          );
        }
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
            if (lastScrolledIndex != null) {
              Future.delayed(const Duration(milliseconds: 100), () {
                if (lastScrolledIndex != null) {
                  _scrollToIndex(lastScrolledIndex!);
                }
              });
            }
            List<FilteredLog> logs = snapshot.data!;
            return StreamBuilder<int?>(
                stream: bloc.observeHighlightedIndex,
                builder: (context, s) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    controller: controller,
                    scrollDirection: scrollDirection,
                    itemCount: logs.length,
                    itemBuilder: (_, index) {
                      return AutoScrollTag(
                        key: ValueKey(logs[index].id),
                        index: logs[index].id,
                        controller: controller,
                        highlightColor: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                        child: _LogItem(
                          log: logs[index],
                          tab: state.tab,
                          isHighlighted: logs[index].id == s.data,
                          onTap: () => bloc
                              .add(ChangeHighlightedMessageEvent(MoveToMessage(logs[index].id))),
                        ),
                      );
                    },
                  );
                });
          },
        );
      },
    );
  }
}

class _LogItem extends StatelessWidget {
  final FilteredLog log;
  final SingleTab tab;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _LogItem({
    Key? key,
    required this.log,
    required this.tab,
    required this.onTap,
    required this.isHighlighted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color logLevelColor = Color(
      log.logMessage.logLevel.color,
    );
    Color backgroundColor = isHighlighted
        ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
        : log.isSearchMatch && tab.filter.search.isNotEmpty && !tab.filter.showOnlySearches
            ? Theme.of(context).colorScheme.disabledTextDark.withAlpha(50)
            : Colors.transparent;
    return ScaleTap(
      scaleMinValue: 0.99,
      onPressed: log.isSearchMatch && tab.filter.search.isNotEmpty ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SelectableText(
                log.logMessage.message,
                style: TextStyle(
                  color: logLevelColor,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: logLevelColor),
                        left: BorderSide(color: logLevelColor),
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: logLevelColor),
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
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
