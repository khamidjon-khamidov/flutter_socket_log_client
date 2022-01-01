import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_state/dialog_states.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/dialogs/add_tab_dialog.dart';
import 'package:flutter_socket_log_client/ui/screens/home/widgets/dialogs/input_ip_dialog.dart';

extension InputIpDialogEx on DialogState {
  void showFromState(BuildContext context) {
    if (this is ShowInputIpDialogState) {
      showDialog(
        context: context,
        builder: (context) => InputIpDialog(
          ip: (this as ShowInputIpDialogState).ip,
          appName: (this as ShowInputIpDialogState).appName,
        ),
      );
    } else if (this is ShowAddTabDialogState) {
      showDialog(
        context: context,
        builder: (context) => AddTabDialog(
          allLogLevels: HashSet.from((this as ShowAddTabDialogState).allLogLevels),
          allLogTags: HashSet.from((this as ShowAddTabDialogState).allLogTags),
          selectedLogLevels: HashSet(),
          selectedLogTags: HashSet(),
        ),
      );
    } else if (this is ShowEditTabDialogState) {
      showDialog(
        context: context,
        builder: (context) => AddTabDialog(
          allLogLevels: HashSet.from((this as ShowEditTabDialogState).allLogLevels),
          allLogTags: HashSet.from((this as ShowEditTabDialogState).allLogTags),
          selectedLogLevels: HashSet(),
          selectedLogTags: HashSet(),
        ),
      );
    }
  }
}
