import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onSave;

  const BaseDialog({
    Key? key,
    required this.title,
    required this.child,
    required this.onSave,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.symmetric(
        vertical: 6.h,
        horizontal: 6,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(title),
      content: child,
      actions: [
        ElevatedButton(
          onPressed: () =>
              Navigator.of(context).pop(), // function used to perform after pressing the button
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: onSave,
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
