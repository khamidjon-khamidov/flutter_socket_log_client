import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/ui/screens/components/color_extensions.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/base_dialog.dart';
import 'package:provider/src/provider.dart';

class AddTabDialog extends StatefulWidget {
  final List<LogTag> allLogTags;
  final List<LogLevel> allLogLevels;
  final List<bool> selectedLogTags;
  final List<bool> selectedLogLevels;

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
        child: ListView(
          physics: const BouncingScrollPhysics(),
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.allLogLevels.isNotEmpty)
              Container(
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
                      child: Text(
                        'Select Log Levels',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 5.sp,
                        ),
                      ),
                    ),
                    Wrap(
                      children: widget.allLogLevels
                          .mapIndexed(
                            (i, e) => _LogItem(
                              name: widget.allLogLevels[i].name,
                              color: widget.allLogLevels[i].color,
                              iconData: widget.allLogLevels[i].iconData,
                              isSelected: widget.selectedLogLevels[i],
                              onTap: () {
                                setState(() {
                                  widget.selectedLogLevels[i] = !widget.selectedLogLevels[i];
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20.h),
            if (widget.allLogTags.isNotEmpty)
              Container(
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
                      child: Text(
                        'Select Log Tags',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 5.sp,
                        ),
                      ),
                    ),
                    Wrap(
                      children: widget.allLogTags
                          .mapIndexed(
                            (i, e) => _LogItem(
                              name: widget.allLogTags[i].name,
                              color: widget.allLogTags[i].color,
                              iconData: widget.allLogTags[i].iconData,
                              isSelected: widget.selectedLogTags[i],
                              onTap: () {
                                setState(() {
                                  widget.selectedLogTags[i] = !widget.selectedLogTags[i];
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
          ],
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
    required this.isSelected,
    required this.onTap,
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
                  fontSize: 6.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
