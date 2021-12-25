import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:rxdart/rxdart.dart';

class SocketClient {
  final BehaviorSubject<LogMessage?> _messageSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool> _connectionStateSubject = BehaviorSubject.seeded(false);

  Stream get messageStream => _messageSubject.stream;
  Stream get connectionStateStream => _connectionStateSubject.stream;

  Socket? _socket;

  Future<void> connectToServer(String ip) async {
    // connect to the socket server
    _socket = await Socket.connect(ip, 4567);
    print('Connected to: ${_socket?.remoteAddress.address}:${_socket?.remotePort}');
    // sending connection message
    _socket?.write('flutter_socket_log_plugin');
    _connectionStateSubject.add(true);

    // listen for logs from the server
    _socket?.listen(
      (Uint8List data) {
        try {
          final logMessage = LogMessage.fromBuffer(data);
          _messageSubject.add(logMessage);
        } catch (e) {
          print('Failed to decode message: $data');
        }
      },

      // handle errors
      onError: (error) {
        print('Socket error: $error');
        removeConnection();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        removeConnection();
      },
    );
  }

  void removeConnection() {
    _socket?.destroy();
    _connectionStateSubject.add(false);
  }
}
