import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/domain/providers/settings_provider.dart';
import 'package:flutter_socket_log_client/domain/providers/socket_client_provider.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:protobuf/protobuf.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepository {
  final SettingsProvider _settingsProvider;
  final SocketClientProvider _socketClientProvider;

  final BehaviorSubject<AppBarData> _appBarSubject =
      BehaviorSubject.seeded(AppBarData('Unknown', 'Ip not initialized'));
  final BehaviorSubject<UserMessage> _userMessageSubject = BehaviorSubject();

  final BehaviorSubject<List<LogMessage>> _messagesSubject = BehaviorSubject.seeded([]);

  final List<LogMessage> allMessages = [];
  bool shouldSetSettingFromMessages = false;

  HomeRepository()
      : _settingsProvider = SettingsProvider(),
        _socketClientProvider = SocketClientProvider() {
    _settings.then((settings) {
      _appBarSubject.add(AppBarData(settings.appName, settings.ip));
    });

    listenMessages();
    listenSettings();
  }

  Stream<AppBarData> get observeAppBarData => _appBarSubject.stream;

  Stream<UserMessage> get observeUserMessages => MergeStream([
        _userMessageSubject.stream,
        _socketClientProvider.observeUserMessage,
      ]);

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
    observeAppBarData.listen((data) {
      shouldSetSettingFromMessages = data.appName == 'Unknown' || data.appName.isEmpty;
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
    if (await _socketClientProvider.connectionStateStream.first) {
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
    _appBarSubject.add(AppBarData(defaultSettings.appName, defaultSettings.ip));
  }

  Future<void> updateIp(String ip) async {
    removeConnection();
    var settings = await _settings;
    saveSettings(settings.rebuild((p0) {
      p0.ip = ip;
    }));
    _appBarSubject.add(AppBarData(settings.appName, settings.ip));
  }

  Future<void> updateAppName(String appName) async {
    var settings = await _settings;
    saveSettings(settings.rebuild((mSettings) {
      mSettings.appName = appName;
    }));
    _appBarSubject.add(AppBarData(settings.appName, settings.ip));
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

class AppBarData {
  final String appName;
  final String ip;

  AppBarData(this.appName, this.ip);
}
