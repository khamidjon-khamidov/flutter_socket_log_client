import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/domain/providers/settings_provider.dart';
import 'package:flutter_socket_log_client/domain/providers/socket_client_provider.dart';
import 'package:protobuf/protobuf.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepository {
  final SettingsProvider _settingsProvider;
  final SocketClientProvider _socketClientProvider;

  final BehaviorSubject<String> _ipSubject = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _appNameSubject = BehaviorSubject.seeded('Unknown');

  final BehaviorSubject<List<LogMessage>> _messagesSubject = BehaviorSubject.seeded([]);

  final List<LogMessage> allMessages = [];
  bool shouldSetSettingFromMessages = false;

  HomeRepository()
      : _settingsProvider = SettingsProvider(),
        _socketClientProvider = SocketClientProvider() {
    _settings.then((settings) {
      _ipSubject.add(settings.ip);
      _appNameSubject.add(settings.appName);
    });

    listenMessages();
    listenSettings();
  }

  Stream<String> get observeIp => _ipSubject.stream;

  Stream<String> get observeAppName => _appNameSubject.stream;

  Stream<bool> get observeSocketConnectionState =>
      _socketClientProvider.connectionStateStream.distinct();

  Stream<List<LogMessage>> get observeAllMessages => _messagesSubject.stream;

  Stream<List<LogMessage>> observeFilteredMessages(TabFilter filter) {
    Set<String> filterSet = filter.logLevels.map((e) => e.name).toSet();

    return _messagesSubject.stream.where((messages) {
      if (messages.isEmpty) return true;

      bool isValid = true;

      isValid &= filterSet.contains(messages.last.logLevel.name);
      Set<String> messageTagSet = messages.last.logTags.map((e) => e.name).toSet();

      isValid &= filterSet.intersection(messageTagSet).isNotEmpty;

      return isValid;
    });
  }

  void listenSettings() {
    observeAppName.listen((appName) {
      shouldSetSettingFromMessages = appName == 'Unknown' || appName.isEmpty;
    });
  }

  void listenMessages() {
    _socketClientProvider.messageStream.where((logMessage) => logMessage != null).map((logMessage) {
      return logMessage!;
    }).listen((message) async {
      if (shouldSetSettingFromMessages) {
        saveSettings((await _settings).rebuild((p0) {
          p0.appName = message.appName;
        }));
      }
      allMessages.add(message);
      _messagesSubject.add(allMessages);
    });
  }

  Future<Settings> get _settings => _settingsProvider.getSettings();

  Future<bool> toggleConnection() async {
    if (await _socketClientProvider.connectionStateStream.last) {
      return _disconnect();
    } else {
      return await _socketClientProvider.connectToServer((await _settings).ip);
    }
  }

  Future<void> setNewIp(String ip) async {
    removeConnection();
    await saveSettings(defaultSettings.rebuild((p0) {
      p0.ip = ip;
    }));
  }

  Future<void> updateIp(String ip) async {
    removeConnection();
    saveSettings((await _settings).rebuild((p0) {
      p0.ip = ip;
    }));
  }

  Future<void> updateAppName(String appName) async {
    saveSettings((await _settings).rebuild((settings) {
      settings.appName = appName;
    }));
  }

  Future<void> saveSettings(Settings settings) => _settingsProvider.setSettings(settings);

  void removeConnection() {
    _socketClientProvider.removeConnection();
  }

  bool _disconnect() {
    _socketClientProvider.destroySocket();
    return true;
  }

  void disposeSocket() {
    _socketClientProvider.destroySocket();
  }
}
