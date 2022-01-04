import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/bottom/check_box_widget.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/bottom/search_box.dart';
import 'package:provider/src/provider.dart';

class BottomFilter extends StatefulWidget {
  const BottomFilter({Key? key}) : super(key: key);

  @override
  State<BottomFilter> createState() => _BottomFilterState();
}

class _BottomFilterState extends State<BottomFilter> {
  late HomeBloc bloc;
  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SearchBox(),
        CheckBoxWidget(),
      ],
    );
  }
}
