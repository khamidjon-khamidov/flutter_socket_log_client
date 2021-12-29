import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

class SocketClientProvider {
  final BehaviorSubject<LogMessage?> _logMessageSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool> _connectionStateSubject = BehaviorSubject.seeded(false);
  final BehaviorSubject<UserMessage> _snackbarMessageSubject = BehaviorSubject();

  Stream<LogMessage?> get observeLogMessages => _logMessageSubject.stream;
  Stream<bool> get connectionStateStream => _connectionStateSubject.stream;

  Stream<UserMessage> get observeSnackbarMessage => _snackbarMessageSubject.stream;

  Socket? _socket;

  Future<bool> connectToServer(String ip) async {
    if (ip.isEmpty || ip == 'Ip not initialized') {
      _snackbarMessageSubject.add(UserMessage.error('Ip is not valid'));
      return false;
    }

    // close and destroy _socket just in case
    _socket?.close();
    _socket?.destroy();

    // connect to the socket server
    try {
      print('trying to connect to ip: $ip, port: 4567');
      _socket = await Socket.connect(ip, 4567);
    } catch (e) {
      print(e.toString());
      _snackbarMessageSubject.add(UserMessage.error(e.toString()));
      return false;
    }

    print('Connected to: ${_socket?.remoteAddress.address}:${_socket?.remotePort}');
    // sending connection message
    if (_socket == null) {
      _snackbarMessageSubject.add(UserMessage.error('Unexpected error happened while connecting'));
      return false;
    }
    await Future.delayed(const Duration(seconds: 2));
    _socket?.write('flutter_socket_log_plugin');
    _connectionStateSubject.add(true);

    // listen for logs from the server
    _socket?.listen(
      (Uint8List data) {
        try {
          final logMessage = LogMessage.fromJson(String.fromCharCodes(data));
          _logMessageSubject.add(logMessage);
        } catch (e) {
          _snackbarMessageSubject.add(UserMessage.error(e.toString()));
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

  void removeConnection() {
    _socket?.close();
    _socket?.destroy();
    _connectionStateSubject.add(false);
  }

  void destroySocket() {
    _socket?.close();
    _socket?.destroy();
  }
}
