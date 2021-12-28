import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/dialogs/base_dialog.dart';
import 'package:provider/src/provider.dart';

class InputIpDialog extends StatefulWidget {
  final String ip;
  final String appName;

  const InputIpDialog({
    Key? key,
    required this.ip,
    required this.appName,
  }) : super(key: key);

  @override
  State<InputIpDialog> createState() => _InputIpDialogState();
}

class _InputIpDialogState extends State<InputIpDialog> {
  final TextEditingController _appNameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();

  late HomeBloc bloc;
  String? ipErrorText;
  String? appNameErrorText;
  bool shouldClear = false;

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    _appNameController.text = widget.appName;
    _ipController.text = widget.ip;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'App Settings',
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
              const Text('Clear previous settings(tabs, app name, etc.)'),
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
