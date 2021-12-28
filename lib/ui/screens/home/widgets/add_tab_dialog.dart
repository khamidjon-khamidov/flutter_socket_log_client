import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/base_dialog.dart';
import 'package:provider/src/provider.dart';

class AddTabDialog extends StatefulWidget {
  final HashSet<LogTag> allLogTags;
  final HashSet<LogLevel> allLogLevels;
  final HashSet<LogTag> selectedLogTags;
  final HashSet<LogLevel> selectedLogLevels;

  const AddTabDialog({
    Key? key,
    required this.allLogTags,
    required this.allLogLevels,
    required this.selectedLogTags,
    required this.selectedLogLevels,
  }) : super(key: key);

  @override
  State<AddTabDialog> createState() => _AddTabDialogState();
}

class _AddTabDialogState extends State<AddTabDialog> {
  late HomeBloc bloc;

  String? errorText;

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Add New Tab',
      saveBtnTitle: 'ADD TAB',
      child: SizedBox(
        width: 400.h,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.allLogLevels.isNotEmpty)
                SelectedLogLevelsSelector(
                  key: const Key('1231231231'),
                  allLogLevels: widget.allLogLevels,
                  selectedLogLevels: widget.selectedLogLevels,
                ),
              SizedBox(height: 20.h),
              if (widget.allLogTags.isNotEmpty)
                Container(
                  width: 350.w,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    // horizontal: 8.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: Theme.of(context).colorScheme.disabledTextDark),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15.h, left: 4.w),
                        child: const Text(
                          'Select Log Tags',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Wrap(
                      //   children: widget.allLogTags
                      //       .mapIndexed(
                      //         (i, e) => _LogItem(
                      //           name: widget.allLogTags[i].name,
                      //           color: widget.allLogTags[i].color,
                      //           iconData: widget.allLogTags[i].iconData,
                      //           isSelected: widget.selectedLogTags[i],
                      //           onTap: () {
                      //             setState(() {
                      //               widget.selectedLogTags[i] = !widget.selectedLogTags[i];
                      //             });
                      //           },
                      //         ),
                      //       )
                      //       .toList(),
                      // ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      onSave: () {
        if (true) {
          setState(() {
            errorText = 'Field cannot be empty';
          });
        } else {
          // bloc.add();
          // Navigator.of(context).pop();
        }
      },
    );
  }
}

class SelectedLogLevelsSelector extends StatefulWidget {
  final Set<LogLevel> allLogLevels;
  final Set<LogLevel> selectedLogLevels;

  const SelectedLogLevelsSelector({
    Key? key,
    required this.allLogLevels,
    required this.selectedLogLevels,
  }) : super(key: key);

  @override
  _SelectedLogLevelsSelectorState createState() => _SelectedLogLevelsSelectorState();
}

class _SelectedLogLevelsSelectorState extends State<SelectedLogLevelsSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: Theme.of(context).colorScheme.disabledTextDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15.h, left: 4.w),
            child: const Text(
              'Select Log Levels',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.allLogLevels.difference(widget.selectedLogLevels).isEmpty)
            Center(
              child: Text(
                'All Log Levels Selected',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.disabledTextDark,
                ),
              ),
            ),
          Wrap(
            children: widget.allLogLevels
                .difference(widget.selectedLogLevels)
                .map((logLevel) => _LogItem(
                      name: logLevel.name,
                      color: logLevel.color,
                      iconData: logLevel.iconData,
                      onTap: () {
                        widget.selectedLogLevels.add(logLevel);
                        setState(() {});
                      },
                    ))
                .toList(),
          ),
          SizedBox(height: 13.h),
          const Divider(height: 2),
          Padding(
            padding: EdgeInsets.only(bottom: 15.h, left: 4.w, top: 10.h),
            child: const Text(
              'Selected',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.selectedLogLevels.isEmpty)
            Center(
              child: Text(
                'Nothing Selected',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.disabledTextDark,
                ),
              ),
            ),
          Wrap(
            children: widget.selectedLogLevels
                .map(
                  (logLevel) => _LogItem(
                    name: logLevel.name,
                    color: logLevel.color,
                    iconData: logLevel.iconData,
                    isSelected: true,
                    onTap: () {
                      widget.selectedLogLevels.remove(logLevel);
                      setState(() {});
                    },
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final String name;
  final int color;
  final int iconData;
  final bool isSelected;
  final VoidCallback onTap;

  const _LogItem({
    Key? key,
    required this.name,
    required this.color,
    required this.iconData,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 4.w,
      ),
      child: ScaleTap(
        onPressed: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
            horizontal: 5.w,
          ),
          decoration: BoxDecoration(
            color: !isSelected ? Colors.transparent : Colors.cyan.withAlpha(100),
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
              color: Colors.cyan,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconData(iconData, fontFamily: 'MaterialIcons'),
                color: Color(color),
              ),
              SizedBox(width: 4.w),
              Text(
                name,
                style: TextStyle(
                  color: Color(color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
