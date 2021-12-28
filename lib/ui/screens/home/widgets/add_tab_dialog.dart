import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/base_dialog.dart';
import 'package:provider/src/provider.dart';

class AddTabDialog extends StatefulWidget {
  final List<LogTag> allLogTags;
  final List<LogLevel> allLogLevels;

  const AddTabDialog({
    Key? key,
    required this.allLogTags,
    required this.allLogLevels,
  }) : super(key: key);

  @override
  State<AddTabDialog> createState() => _AddTabDialogState();
}

class _AddTabDialogState extends State<AddTabDialog> {
  final TextEditingController _appNameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();

  late HomeBloc bloc;
  String? ipErrorText;
  String? appNameErrorText;
  bool shouldClear = false;

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Add New Tab',
      saveBtnTitle: 'SAVE',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _appNameController,
            onChanged: (_) {
              setState(() {
                appNameErrorText = null;
              });
            },
            decoration: InputDecoration(
              errorText: appNameErrorText,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.disabledTextDark),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).highlightColor),
              ),
              hintText: 'App Name',
            ),
          ),
          TextField(
            controller: _ipController,
            onChanged: (_) {
              setState(() {
                ipErrorText = null;
              });
            },
            decoration: InputDecoration(
              errorText: ipErrorText,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.disabledTextDark),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).highlightColor),
              ),
              hintText: 'IP address of device your App running on',
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Checkbox(
                value: shouldClear,
                onChanged: (value) {
                  setState(() {
                    shouldClear = value ?? false;
                  });
                },
              ),
              Text(
                'Clear previous settings(tabs, app name, etc.)',
                style: TextStyle(fontSize: 6.sp),
              ),
            ],
          ),
        ],
      ),
      onSave: () {
        if (_ipController.text.isEmpty) {
          setState(() {
            ipErrorText = 'Ip address cannot be empty';
          });
        } else {
          bloc.add(
            UpdateAppSettingsEvent(
              ip: _ipController.text,
              appName: _appNameController.text,
              shouldClearSettings: shouldClear,
            ),
          );
          Navigator.of(context).pop();
        }
      },
    );
  }
}
