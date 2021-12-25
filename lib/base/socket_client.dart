import 'dart:io';
import 'dart:typed_data';

import 'package:rxdart/rxdart.dart';

class SocketClient {
  BehaviorSubject
  Future<void> connectToServer() async {
    // connect to the socket server
    final socket = await Socket.connect('localhost', 4567);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    // listen for responses from the server
    socket.listen(
      // handle data from the server
      (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        print('Server: $serverResponse');
      },

      // handle errors
      onError: (error) {
        print(error);
        socket.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        socket.destroy();
      },
    );
  }

  Future<void> sendMessage(Socket socket, String message) async {
    print('Client: $message');
    socket.write(message);
    await Future.delayed(Duration(seconds: 2));
  }
}
