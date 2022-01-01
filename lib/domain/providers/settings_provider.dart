import 'dart:convert';

import 'package:flutter_socket_log_client/base/preferences_helper.dart';
import 'package:flutter_socket_log_client/domain/models/offline/settings.dart';

class SettingsProvider {
  static const _SETTINGS_KEY = '_SETTINGS_KEY';

  Future<Settings> getSettings() async {
    String? mjson = await PreferencesHelper.getString(_SETTINGS_KEY);
    if (mjson == null) {
      await setSettings(Settings.defaultSettings());
      return getSettings();
    }
    return Settings.fromJson(json.decode(mjson));
  }

  Future<void> setSettings(Settings settings) =>
      PreferencesHelper.setString(_SETTINGS_KEY, json.encode(settings.toJson()));

  Future<void> clearSettings() => PreferencesHelper.setString(_SETTINGS_KEY, null);
}
