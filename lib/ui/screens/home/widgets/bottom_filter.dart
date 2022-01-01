import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/bottom_events.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/bottom_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/home_state.dart';
import 'package:provider/src/provider.dart';

class BottomFilter extends StatefulWidget {
  const BottomFilter({Key? key}) : super(key: key);

  @override
  State<BottomFilter> createState() => _BottomFilterState();
}

class _BottomFilterState extends State<BottomFilter> {
  late HomeBloc bloc;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(),
              child: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (_, state) => state is BottomState,
                builder: (context, state) {
                  if (state is! BottomState) {
                    return const CircularProgressIndicator();
                  }
                  _controller.text = state.tab.filter.search;

                  return TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.disabledTextDark),
                      hintText: "Search",
                      fillColor: Theme.of(context).primaryColor,
                    ),
                    onChanged: (filter) {
                      bloc.add(SearchEvent(filter, state.tab));
                    },
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Checkbox(
            value: true,
            onChanged: (_) {},
          ),
        ),
      ],
    );
  }
}
