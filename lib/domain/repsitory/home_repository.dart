import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/domain/providers/settings_provider.dart';
import 'package:flutter_socket_log_client/domain/providers/socket_client_provider.dart';
import 'package:rxdart/rxdart.dart';

Tab defaultTab = Tab.create()
  ..id = 0
  ..name = 'All'
  ..showOnlySearches = false;
Settings defaultSettings = Settings.create()
  ..ip = ''
  ..appName = 'Unknown'
  ..tabs.add(defaultTab);

class HomeRepository {
  final SettingsProvider _settingsProvider;
  final SocketClientProvider _socketClientProvider;
  final BehaviorSubject<Settings> _settingsSubject = BehaviorSubject.seeded(defaultSettings);

  HomeRepository()
      : _settingsProvider = SettingsProvider(),
        _socketClientProvider = SocketClientProvider() {
    settings.then((settings) {
      if (settings == null) {
        _settingsSubject.add(defaultSettings);
      } else {
        _settingsSubject.add(settings);
      }
    });
  }

  Future<Settings?> get settings => _settingsProvider.getSettings();

  Future<void> connectToServer(String ip) => _socketClientProvider.connectToServer(ip);

  Future<void> saveSettings(Settings settings) async {
    await _settingsProvider.setSettings(settings);
    _settingsSubject.add(settings);
  }

  Future<void> clearAll() async {
    _socketClientProvider.removeConnection();
    _settingsProvider.clearSettings();
    _settingsSubject.add(defaultSettings);
  }

  Stream<bool> get socketConnectionStateStream => _socketClientProvider.connectionStateStream;

  Stream<LogMessage> get logMessageStream => _socketClientProvider.messageStream
      .where((logMessage) => logMessage != null)
      .map((logMessage) => logMessage!);

  void disposeSocket() {
    _socketClientProvider.destroySocket();
  }
}
