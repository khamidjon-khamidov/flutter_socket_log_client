import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';
import 'package:flutter_socket_log_client/domain/providers/settings_provider.dart';
import 'package:flutter_socket_log_client/domain/providers/socket_client_provider.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepository {
  final SettingsProvider _settingsProvider;
  final SocketClientProvider _socketClientProvider;

  final BehaviorSubject<AppBarData> _appBarSubject =
      BehaviorSubject.seeded(AppBarData('Unknown', 'Ip not initialized'));
  final BehaviorSubject<UserMessage> _snackbarMessageSubject = BehaviorSubject();

  final BehaviorSubject<List<LogMessage>> _logSubject = BehaviorSubject.seeded([]);

  final List<LogMessage> allLogs = [];
  bool shouldSetSettingFromMessages = false;

  HomeRepository()
      : _settingsProvider = SettingsProvider(),
        _socketClientProvider = SocketClientProvider() {
    _settings.then((settings) {
      _appBarSubject.add(AppBarData(settings.appName, settings.ip));
    });

    listenLogs();
    listenSettings();
  }

  Stream<AppBarData> get observeAppBarData => _appBarSubject.stream;

  Future<AppBarData> get appBarData async {
    Settings settings = await _settings;
    return AppBarData(settings.appName, settings.ip);
  }

  Stream<UserMessage> get observeSnackbarMessages => MergeStream([
        _snackbarMessageSubject.stream,
        _socketClientProvider.observeSnackbarMessage,
      ]);

  Stream<bool> get observeSocketConnectionState =>
      _socketClientProvider.connectionStateStream.distinct();

  Stream<List<LogMessage>> get observeAllLogs => _logSubject.stream;

  Stream<List<LogMessage>> observeFilteredMessages(TabFilter filter) {
    Set<String> filterSet = filter.logLevels.map((e) => e.name).toSet();

    return _logSubject.stream.where((logs) {
      if (logs.isEmpty) return true;

      bool isValid = true;

      isValid &= filterSet.contains(logs.last.logLevel.name);
      Set<String> messageTagSet = logs.last.logTags.map((e) => e.name).toSet();

      isValid &= filterSet.intersection(messageTagSet).isNotEmpty;

      return isValid;
    });
  }

  Future<List<Tab>> saveTab(String tabName, Set<LogTag> logTags, Set<LogLevel> logLevels) async {
    int id = 1;
    Settings settings = await _settings;
    List<Tab> tabs = settings.tabs;
    for (var tab in tabs) {
      if (tab.id >= id) id = tab.id + 1;
    }
    Tab newTab = _createTab(id, tabName, logTags, logLevels);
    settings.tabs.add(newTab);
    await saveSettings(settings);
    return [
      _createTab(0, 'All', {}, {}),
      ...settings.tabs,
    ];
  }

  Future<List<Tab>> editTab({
    required String newTabName,
    required Tab tab,
    required Set<LogTag> logTags,
    required Set<LogLevel> logLevels,
  }) async {
    Settings settings = await _settings;
    settings.tabs.remove(tab);

    tab.name = newTabName;
    tab.filter.logLevels.clear();
    tab.filter.logLevels.addAll(logLevels);
    tab.filter.tags.clear();
    tab.filter.tags.addAll(logTags);

    settings.tabs.add(tab);

    await saveSettings(settings);
    return [
      _createTab(0, 'All', {}, {}),
      ...settings.tabs,
    ];
  }

  Future<List<Tab>> deleteTab(Tab tab) async {
    Settings settings = await _settings;
    settings.tabs.remove(tab);
    await saveSettings(settings);
    return [
      _createTab(0, 'All', {}, {}),
      ...settings.tabs,
    ];
  }

  Future<List<Tab>> get tabs async {
    return [
      _createTab(0, 'All', {}, {}),
      ...(await _settings).tabs,
    ];
  }

  Tab _createTab(int id, String tabName, Set<LogTag> tags, Set<LogLevel> levels) {
    TabFilter filter = TabFilter.create()
      ..name = ''
      ..logLevels.addAll(levels)
      ..tags.addAll(tags);

    return Tab.create()
      ..id = id
      ..name = tabName
      ..filter = filter
      ..showOnlySearches = false;
  }

  Future<Settings> getSettings() => _settings;

  List<LogTag>? get allLogTags {
    if (allLogs.isEmpty) return null;
    return allLogs.last.allLogTags;
  }

  List<LogLevel>? get allLogLevels {
    if (allLogs.isEmpty) return null;
    return allLogs.last.allLogLevels;
  }

  void listenSettings() {
    observeAppBarData.listen((data) {
      shouldSetSettingFromMessages = data.appName == 'Unknown' || data.appName.isEmpty;
    });
  }

  void listenLogs() {
    _socketClientProvider.observeLogMessages
        .where((logMessage) => logMessage != null)
        .map((logMessage) {
      return logMessage!;
    }).listen((LogMessage logMessage) async {
      print('got new log');
      if (shouldSetSettingFromMessages) {
        print('trying Set settings from message');
        saveSettings((await _settings)..appName = logMessage.appName);
      }
      allLogs.add(logMessage);
      _logSubject.add(allLogs);
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

  Future<void> updateAppNameAndIp(String ip, String appName, bool shouldClear) async {
    removeConnection();
    Settings settings = shouldClear ? defaultSettings : await _settings;

    settings.ip = ip;
    settings.appName = appName;

    await saveSettings(settings);
    _appBarSubject.add(AppBarData(
      settings.appName,
      settings.ip,
    ));
  }

  Future<void> updateAppName(String appName) async {
    var settings = (await _settings)..appName = appName;
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
