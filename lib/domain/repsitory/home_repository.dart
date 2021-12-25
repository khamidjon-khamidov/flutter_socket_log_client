import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/domain/providers/settings_provider.dart';
import 'package:flutter_socket_log_client/domain/providers/socket_client_provider.dart';

class HomeRepository {
  final SettingsProvider _settingsProvider;
  final SocketClientProvider _socketClientProvider;

  HomeRepository()
      : _settingsProvider = SettingsProvider(),
        _socketClientProvider = SocketClientProvider();

  Future<void> connectToServer(String ip) => _socketClientProvider.connectToServer(ip);

  Future<void> saveSettings(Settings settings) => _settingsProvider.setSettings(settings);

  Future<Settings?> get settings => _settingsProvider.getSettings();

  Stream<bool> get socketConnectionStateStream => _socketClientProvider.connectionStateStream;

  Stream<LogMessage?> get logMessageStream => _socketClientProvider.messageStream;

  void disposeSocket() {
    _socketClientProvider.destroySocket();
  }
}
