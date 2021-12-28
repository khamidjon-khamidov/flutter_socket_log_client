import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart' as protos;
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
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
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, current) => current is TabsState,
      builder: (c, state) {
        if (state is TabsState) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // scrollDirection: Axis.horizontal,
              children: state.tabs
                  .map(
                    (tab) => _TabItem(
                      tab: tab,
                      isSelected: tab.id == state.selectedTabId,
                      onTap: (protos.Tab tab) {
                        bloc.add(TabSelectedEvent(tab));
                      },
                      onCloseTap: (tab) {
                        print('Close clicked');
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final protos.Tab tab;
  final bool isSelected;
  final Function(protos.Tab tab) onTap;
  final Function(protos.Tab tab) onCloseTap;

  const _TabItem({
    Key? key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
    required this.onCloseTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onPressed: () => onTap(tab),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: tab.id == 0 ? 5 : 4,
          horizontal: tab.id == 0 ? 7 : 7,
        ),
        decoration: BoxDecoration(
          color: !isSelected
              ? Theme.of(context).colorScheme.disabledTextDark.withAlpha(30)
              : Colors.cyan.withAlpha(50),
          border: Border(
            right: const BorderSide(color: Colors.grey),
            bottom: BorderSide(
              color: isSelected ? Colors.cyan : Colors.grey,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tab.id != 0)
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.grey,
                ),
                onTap: () => onCloseTap(tab),
              ),
            const SizedBox(width: 9),
            Text(tab.name),
            const SizedBox(width: 9),
          ],
        ),
      ),
    );
  }
}
