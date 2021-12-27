import 'package:flutter_socket_log_client/base/preferences_helper.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

Tab defaultTab = Tab.create()
  ..id = 0
  ..name = 'All'
  ..showOnlySearches = false;

Settings defaultSettings = Settings.create()
  ..ip = 'Ip not initialized'
  ..appName = 'Unknown'
  ..tabs.add(defaultTab);

class SettingsProvider {
  static const _SETTINGS_KEY = '_SETTINGS_KEY';

  Future<Settings> getSettings() async {
    String? json = await PreferencesHelper.getString(_SETTINGS_KEY);
    if (json == null) {
      return defaultSettings;
    }
    return Settings.fromJson(json);
  }

  Future<void> setSettings(Settings settings) =>
      PreferencesHelper.setString(_SETTINGS_KEY, settings.writeToJson());

  Future<void> clearSettings() => PreferencesHelper.setString(_SETTINGS_KEY, null);
}
