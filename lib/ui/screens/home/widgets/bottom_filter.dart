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
  final TextEditingController _controller = TextEditingController();

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
                  _controller.selection =
                      TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

                  return TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: state.tab.filter.search.isNotEmpty
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: state.tab.filter.search.isNotEmpty
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).primaryColor),
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
          child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (_, state) => state is BottomState,
              builder: (context, state) {
                if (state is! BottomState) {
                  return const CircularProgressIndicator();
                }
                return Checkbox(
                  value: state.tab.filter.showOnlySearches,
                  onChanged: (newValue) {
                    bloc.add(ShowOnlySearchesEvent(newValue ?? false, state.tab));
                  },
                );
              }),
        ),
      ],
    );
  }
}
