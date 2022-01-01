import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';
import 'package:flutter_socket_log_client/domain/models/offline/filtered_log.dart';
import 'package:flutter_socket_log_client/domain/models/offline/settings.dart';
import 'package:flutter_socket_log_client/domain/models/offline/tab.dart';
import 'package:flutter_socket_log_client/domain/models/offline/tab_filter.dart';
import 'package:flutter_socket_log_client/domain/providers/settings_provider.dart';
import 'package:flutter_socket_log_client/domain/providers/socket_client_provider.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/ui_message.dart';
import 'package:flutter_socket_log_client/util/custom_filter.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepository {
  final SettingsProvider _settingsProvider;
  final SocketClientProvider _socketClientProvider;

  final BehaviorSubject<AppBarData> _appBarSubject =
      BehaviorSubject.seeded(AppBarData('Unknown', 'Ip not initialized'));
  final BehaviorSubject<UserMessage> _snackbarMessageSubject = BehaviorSubject();

  final BehaviorSubject<List<LogMessage>> _allLogsSubject = BehaviorSubject.seeded([]);

  final List<LogMessage> allLogs = [];
  bool shouldSetSettingFromMessages = false;
  TabFilter _currentFilter = TabFilter.defaultFilter();

  HomeRepository()
      : _settingsProvider = SettingsProvider(),
        _socketClientProvider = SocketClientProvider() {
    _settings.then((settings) {
      _appBarSubject.add(AppBarData(settings.appName, settings.ip));
    });

    listenLogs();
    listenAppBarData();
  }

  Stream<AppBarData> get observeAppBarData => _appBarSubject.stream;

  Stream<List<FilteredLog>> get observeFilteredLogs {
    return _allLogsSubject.stream
        .switchMap<List<LogMessage>>((value) => Stream.value(value.reversed.toList()))
        .switchMap((List<LogMessage> logs) => Stream.value(_currentFilter.applyFilter(logs)));
  }

  Future<Set<SingleTab>> get tabs async => (await _settings).tabs;

  Future<SingleTab> get defaultTab async => (await tabs).firstWhere((element) => element.id == 0);

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

  void setFilter(TabFilter filter) => _currentFilter = filter;

  Future<SingleTab> addTab(String tabName, Set<LogTag> logTags, Set<LogLevel> logLevels) async {
    int id = 1;
    Settings settings = await _settings;
    Set<SingleTab> tabs = settings.tabs;
    for (var tab in tabs) {
      if (tab.id >= id) id = tab.id + 1;
    }
    SingleTab newTab = _createTab(id, tabName, logTags, logLevels);
    settings.tabs.add(newTab);
    await saveSettings(settings);
    return newTab;
  }

  Future<SingleTab> updateSearchInTab(String search, SingleTab tab) async {
    Settings settings = await _settings;
    settings.tabs.remove(tab);
    tab.filter.setSearch(search);
    settings.tabs.add(tab);
    await saveSettings(settings);

    return tab;
  }

  Future<SingleTab> updateShowOnlySearchesInTab(bool showOnlySearchesInTab, SingleTab tab) async {
    Settings settings = await _settings;
    settings.tabs.remove(tab);
    tab.filter.setShowOnlySearches(showOnlySearchesInTab);
    settings.tabs.add(tab);
    await saveSettings(settings);

    return tab;
  }

  Future<SingleTab> updateSearchFilterInTab(String search, SingleTab tab) async {
    Settings settings = await _settings;
    settings.tabs.remove(tab);

    tab.filter.setSearch(search);
    settings.tabs.add(tab);
    await saveSettings(settings);

    return tab;
  }

  Future<SingleTab> editTab({
    required String newTabName,
    required SingleTab tab,
    required Set<LogTag> logTags,
    required Set<LogLevel> logLevels,
  }) async {
    Settings settings = await _settings;
    settings.tabs.remove(tab);

    tab.setName(newTabName);
    tab.filter.logLevels.clear();
    tab.filter.logLevels.addAll(logLevels);
    tab.filter.tags.clear();
    tab.filter.tags.addAll(logTags);

    settings.tabs.add(tab);

    await saveSettings(settings);

    return tab;
  }

  Future<Set<SingleTab>> deleteTab(SingleTab tab) async {
    Settings settings = await _settings;
    settings.tabs.remove(tab);
    await saveSettings(settings);
    return settings.tabs;
  }

  SingleTab _createTab(int id, String tabName, Set<LogTag> tags, Set<LogLevel> levels) {
    TabFilter filter = TabFilter(
      '',
      false,
      tags: tags,
      logLevels: levels,
    );

    return SingleTab(tabName, id: id, filter: filter);
  }

  Future<Settings> getSettings() => _settings;

  void clearMessages() {
    allLogs.clear();
    _allLogsSubject.add(allLogs);
  }

  List<LogTag>? get allLogTags {
    if (allLogs.isEmpty) return null;
    return allLogs.last.allLogTags;
  }

  List<LogLevel>? get allLogLevels {
    if (allLogs.isEmpty) return null;
    return allLogs.last.allLogLevels;
  }

  void listenAppBarData() {
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
      if (shouldSetSettingFromMessages) {
        saveSettings((await _settings)..setAppName(logMessage.appName));
      }
      allLogs.add(logMessage);
      _allLogsSubject.add(allLogs);
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
    Settings settings = shouldClear ? Settings.defaultSettings() : await _settings;

    settings
      ..setAppName(appName)
      ..setIp(ip);

    await saveSettings(settings);
    _appBarSubject.add(AppBarData(
      settings.appName,
      settings.ip,
    ));
  }

  Future<void> updateAppName(String appName) async {
    var settings = (await _settings)..setAppName(appName);
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
