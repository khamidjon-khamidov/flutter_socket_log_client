import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/domain/models/remote_models/log_level.dart';
import 'package:flutter_socket_log_client/domain/models/remote_models/log_tag.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/tab.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_event/top_events.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/dialogs/base_dialog.dart';
import 'package:provider/src/provider.dart';

class EditTabDialog extends StatefulWidget {
  final SingleTab tab;
  final HashSet<LogTag> allLogTags;
  final HashSet<LogLevel> allLogLevels;
  final HashSet<LogTag> selectedLogTags;
  final HashSet<LogLevel> selectedLogLevels;

  const EditTabDialog({
    Key? key,
    required this.tab,
    required this.allLogTags,
    required this.allLogLevels,
    required this.selectedLogTags,
    required this.selectedLogLevels,
  }) : super(key: key);

  @override
  State<EditTabDialog> createState() => _EditTabDialogState();
}

class _EditTabDialogState extends State<EditTabDialog> {
  late HomeBloc bloc;
  final ScrollController _controller = ScrollController();
  final TextEditingController _textController = TextEditingController();

  String? errorText;

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    _textController.text = widget.tab.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Edit Tab',
      saveBtnTitle: 'SAVE',
      child: SizedBox(
        width: 400.h,
        child: SingleChildScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _textController,
                onChanged: (_) {
                  setState(() {
                    errorText = null;
                  });
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.disabledTextDark),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).highlightColor),
                  ),
                  hintText: 'Enter Tab Name',
                ),
              ),
              SizedBox(height: 15.h),
              if (widget.allLogLevels.isNotEmpty)
                SelectedLogLevelsSelector(
                  allLogLevels: widget.allLogLevels,
                  selectedLogLevels: widget.selectedLogLevels,
                ),
              SizedBox(height: 20.h),
              if (widget.allLogTags.isNotEmpty)
                SelectedLogTagsSelector(
                  allLogTags: widget.allLogTags,
                  selectedLogTags: widget.selectedLogTags,
                ),
              SizedBox(height: 10.h),
              if (errorText != null)
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      onSave: () {
        if (_textController.text.isEmpty) {
          setState(() {
            errorText = 'Tab name cannot be empty';
            _controller.animateTo(
              _controller.position.maxScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          });
        } else if (widget.selectedLogTags.isEmpty && widget.selectedLogLevels.isEmpty) {
          setState(() {
            _controller.animateTo(
              _controller.position.maxScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
            errorText = 'At least one of the fields should be empty';
          });
        } else {
          bloc.add(
            EditTabEvent(
              tab: widget.tab,
              newName: _textController.text,
              selectedTags: widget.selectedLogTags,
              selectedLogLevels: widget.selectedLogLevels,
            ),
          );
          Navigator.of(context).pop();
        }
      },
    );
  }
}

class SelectedLogTagsSelector extends StatefulWidget {
  final Set<LogTag> allLogTags;
  final Set<LogTag> selectedLogTags;

  const SelectedLogTagsSelector({
    Key? key,
    required this.allLogTags,
    required this.selectedLogTags,
  }) : super(key: key);

  @override
  _SelectedLogTagsSelectorState createState() => _SelectedLogTagsSelectorState();
}

class _SelectedLogTagsSelectorState extends State<SelectedLogTagsSelector> {
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
              'Select Log Tags',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.allLogTags.difference(widget.selectedLogTags).isEmpty)
            Center(
              child: Text(
                'All Log Tags Selected',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.disabledTextDark,
                ),
              ),
            ),
          Wrap(
            children: widget.allLogTags
                .difference(widget.selectedLogTags)
                .map((logLevel) => _LogItem(
                      name: logLevel.name,
                      color: logLevel.color,
                      iconData: logLevel.iconData,
                      onTap: () {
                        widget.selectedLogTags.add(logLevel);
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
          if (widget.selectedLogTags.isEmpty)
            Center(
              child: Text(
                'Nothing Selected',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.disabledTextDark,
                ),
              ),
            ),
          Wrap(
            children: widget.selectedLogTags
                .map(
                  (logLevel) => _LogItem(
                    name: logLevel.name,
                    color: logLevel.color,
                    iconData: logLevel.iconData,
                    isSelected: true,
                    onTap: () {
                      widget.selectedLogTags.remove(logLevel);
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
