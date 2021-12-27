import 'package:flutter/material.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/base_dialog.dart';

class InputIpDialog extends StatefulWidget {
  InputIpDialog({Key? key}) : super(key: key);

  @override
  State<InputIpDialog> createState() => _InputIpDialogState();
}

class _InputIpDialogState extends State<InputIpDialog> {
  final TextEditingController _controller = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Ip Settings',
      child: TextField(
        controller: _controller,
        onChanged: (_) {
          setState(() {
            errorText = null;
          });
        },
        decoration: InputDecoration(
          errorText: errorText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.disabledTextDark),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).highlightColor),
          ),
          hintText: 'IP address of device your App running on',
        ),
      ),
      onSave: () {
        if (_controller.text.isEmpty) {
          setState(() {
            errorText = 'Ip address cannot be empty';
          });
        }
      },
    );
  }
}
