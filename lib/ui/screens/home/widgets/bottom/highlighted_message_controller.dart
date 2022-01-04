import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:provider/src/provider.dart';

class HighLightedMessageController extends StatefulWidget {
  const HighLightedMessageController({Key? key}) : super(key: key);

  @override
  State<HighLightedMessageController> createState() => _HighLightedMessageControllerState();
}

class _HighLightedMessageControllerState extends State<HighLightedMessageController> {
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
          ),
          onPressed: () {
            // todo implement
          },
        ),
        const SizedBox(width: 5),
        const Text(
          '34',
          style: TextStyle(fontSize: 18),
        ),
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
                // todo
              },
            ),
            ScaleTap(
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.mediumEmphasisTextDark,
              ),
              onPressed: () {
                // todo
              },
            )
          ],
        ),
        const SizedBox(width: 15)
      ],
    );
  }
}
