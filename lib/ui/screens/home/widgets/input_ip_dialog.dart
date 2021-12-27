import 'package:flutter/material.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/base_dialog.dart';

class InputIpDialog extends StatelessWidget {
  const InputIpDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Ip Settings',
      child: Text('Do something'),
      onSave: () {},
    );
  }
}
