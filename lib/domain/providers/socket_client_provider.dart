import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_socket_log_client/domain/models/connection_state.dart';
import 'package:flutter_socket_log_client/domain/models/remote_models/log_level.dart';
import 'package:flutter_socket_log_client/domain/models/remote_models/log_message.dart';
import 'package:flutter_socket_log_client/domain/models/remote_models/log_tag.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

class SocketClientProvider {
  static const String _separator = '*#+k_!';

  final BehaviorSubject<LogMessage?> _logMessageSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<SocketConnectionState> _connectionStateSubject =
      BehaviorSubject.seeded(SocketConnectionState.disconnected);
  final BehaviorSubject<UserMessage> _snackbarMessageSubject = BehaviorSubject();

  Stream<LogMessage?> get observeLogMessages => _logMessageSubject.stream;
  Stream<SocketConnectionState> get connectionStateStream => _connectionStateSubject.stream;

  Stream<UserMessage> get observeSnackbarMessage => _snackbarMessageSubject.stream;

  Socket? _socket;

  Future<bool> connectToServer(String ip) async {
    _connectionStateSubject.add(SocketConnectionState.loading);
    if (ip.isEmpty || ip == 'Ip not initialized') {
      _connectionStateSubject.add(SocketConnectionState.disconnected);
      _snackbarMessageSubject.add(UserMessage.error('Ip is not valid'));
      return false;
    }

    // close and destroy _socket just in case
    destroySocket();

    // connect to the socket server
    try {
      print('trying to connect to ip: $ip, port: 4567');
      _socket = await Socket.connect(ip, 4567, timeout: const Duration(seconds: 10));
    } catch (e) {
      print(e.toString());
      _snackbarMessageSubject.add(UserMessage.error(e.toString()));
      _connectionStateSubject.add(SocketConnectionState.disconnected);
      return false;
    }

    print('Connected to: ${_socket?.remoteAddress.address}:${_socket?.remotePort}');
    // sending connection message
    if (_socket == null) {
      _connectionStateSubject.add(SocketConnectionState.disconnected);
      _snackbarMessageSubject.add(UserMessage.error('Unexpected error happened while connecting'));
      return false;
    }
    await Future.delayed(const Duration(seconds: 2));
    _socket?.write('flutter_socket_log_plugin');
    _connectionStateSubject.add(SocketConnectionState.connected);

    // listen for logs from the server
    _socket?.listen(
      (Uint8List data) {
        String jsonString = String.fromCharCodes(data);
        List<String> jsons = jsonString.split(_separator);
        for (var js in jsons) {
          if (js.isNotEmpty) {
            LogMessage? m = parseMessage(js);
            if (m == null) {
              _logMessageSubject.add(createMessageFromString(js));
            } else {
              _logMessageSubject.add(m);
            }
          }
        }
      },
      // handle errors
      onError: (error) {
        _snackbarMessageSubject.add(UserMessage.error(error.toString()));
        print('Socket error: $error');
        removeConnection();
      },
      // handle server ending connection
      onDone: () {
        print('Server left.');
        removeConnection();
      },
    );
    return true;
  }

  LogMessage? parseMessage(String js) {
    try {
      return LogMessage.fromJson(json.decode(js));
    } catch (e) {
      print('Got error: json: $js');
      print('Tried 3 times. Error: $e');
      return null;
    }
  }

  LogMessage createMessageFromString(String message) {
    LogLevel level = LogLevel(
      name: 'Log could not be parsed',
      color: Colors.white.value,
      iconData: Icons.warning.codePoint,
    );

    LogMessage logMessage = LogMessage(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      appName: '',
      message: 'Log: $message',
      logTags: [],
      allLogTags: [
        LogTag(
          name: 'Unknown Empty Message',
          color: Colors.white.value,
          iconData: Icons.warning.codePoint,
        )
      ],
      allLogLevels: [],
      logLevel: level,
    );

    print('Sending empty message: $logMessage');
    return logMessage;
  }

  void removeConnection() {
    _socket?.close();
    _socket?.destroy();
    _connectionStateSubject.add(SocketConnectionState.disconnected);
  }

  void destroySocket() {
    _socket?.close();
    _socket?.destroy();
    _connectionStateSubject.add(SocketConnectionState.disconnected);
  }
}
