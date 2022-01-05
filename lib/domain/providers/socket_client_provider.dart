import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_socket_log_client/domain/models/connection_state.dart';
import 'package:flutter_socket_log_client/domain/models/proto_models/communication.pb.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

class SocketClientProvider {
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
    _socket?.close();
    _socket?.destroy();

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
        try {
          final logMessage = LogMessage.fromJson(String.fromCharCodes(data));
          _logMessageSubject.add(logMessage);
        } catch (e) {
          print('Got error: json: ${String.fromCharCodes(data)}');
          print('Error: $e');
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
    _connectionStateSubject.add(SocketConnectionState.disconnected);
  }

  void destroySocket() {
    _socket?.close();
    _socket?.destroy();
    _connectionStateSubject.add(SocketConnectionState.disconnected);
  }
}
