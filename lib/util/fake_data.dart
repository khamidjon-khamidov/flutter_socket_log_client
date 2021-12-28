import 'package:flutter/material.dart';
import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';

List<LogTag> fakeLogTags = [
  LogTag.create()
    ..name = 'Bluetooth'
    ..color = Colors.blue.value
    ..iconData = Icons.bluetooth.codePoint,
  LogTag.create()
    ..name = 'Network'
    ..color = Colors.red.value
    ..iconData = Icons.network_wifi.codePoint,
];
List<LogLevel> fakeLogLevels = [
  LogLevel.create()
    ..name = 'Error'
    ..color = Colors.red.value
    ..iconData = Icons.error.codePoint,
  LogLevel.create()
    ..name = 'Debug'
    ..color = Colors.white.value
    ..iconData = Icons.bug_report.codePoint,
  LogLevel.create()
    ..name = 'Warning'
    ..color = Colors.yellow.value
    ..iconData = Icons.warning.codePoint,
  LogLevel.create()
    ..name = 'Success'
    ..color = Colors.green.value
    ..iconData = Icons.done.codePoint,
  LogLevel.create()
    ..name = 'Success'
    ..color = Colors.green.value
    ..iconData = Icons.done.codePoint,
  LogLevel.create()
    ..name = 'Info'
    ..color = Colors.blue.value
    ..iconData = Icons.info.codePoint,
];
