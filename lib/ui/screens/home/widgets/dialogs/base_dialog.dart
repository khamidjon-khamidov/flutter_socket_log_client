import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseDialog extends StatelessWidget {
  final String title;
  final String saveBtnTitle;
  final Widget child;
  final VoidCallback onSave;

  const BaseDialog({
    Key? key,
    required this.title,
    required this.saveBtnTitle,
    required this.child,
    required this.onSave,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.symmetric(
        vertical: 6.h,
        horizontal: 6.h,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(title),
      content: child,
      actions: [
        ScaleTap(
          onPressed: () {},
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
        ),
        ScaleTap(
          onPressed: () {},
          child: ElevatedButton(
            onPressed: onSave,
            child: Text(saveBtnTitle),
          ),
        ),
      ],
    );
  }
}
