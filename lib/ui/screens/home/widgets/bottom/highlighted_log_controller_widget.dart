import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_socket_log_client/domain/models/move_highlighted_message_type.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/bottom_events.dart';
import 'package:provider/src/provider.dart';

class HighLightedMessageControllerWidget extends StatefulWidget {
  const HighLightedMessageControllerWidget({Key? key}) : super(key: key);

  @override
  State<HighLightedMessageControllerWidget> createState() =>
      _HighLightedMessageControllerWidgetState();
}

class _HighLightedMessageControllerWidgetState extends State<HighLightedMessageControllerWidget> {
  late HomeBloc bloc;

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTap(
          child: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.mediumEmphasisTextDark,
            size: 20,
          ),
          onPressed: () {
            // todo implement
          },
        ),
        const SizedBox(width: 5),
        StreamBuilder<int?>(
            stream: bloc.observeHighlightedLogId,
            builder: (c, s) {
              return Text(
                '${s.data != null ? s.data! + 1 : 0}',
                style: const TextStyle(fontSize: 18),
              );
            }),
        StreamBuilder<int?>(
            stream: bloc.observeMatchedLogsCount,
            builder: (context, snapshot) {
              return Text(
                ' / ${snapshot.data ?? 0}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.disabledTextDark,
                ),
              );
            }),
        const SizedBox(width: 5),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTap(
              child: Icon(
                Icons.keyboard_arrow_up,
                color: Theme.of(context).colorScheme.mediumEmphasisTextDark,
              ),
              onPressed: () {
                bloc.add(
                  ChangeHighlightedMessageEvent(
                    MoveToNext(),
                  ),
                );
              },
            ),
            ScaleTap(
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.mediumEmphasisTextDark,
              ),
              onPressed: () {
                bloc.add(
                  ChangeHighlightedMessageEvent(
                    MoveToPrevious(),
                  ),
                );
              },
            )
          ],
        ),
        const SizedBox(width: 15)
      ],
    );
  }
}
