import 'dart:convert';

import 'package:flutter_socket_log_client/base/preferences_helper.dart';
import 'package:flutter_socket_log_client/domain/models/serialized_models/settings.dart';

class SettingsProvider {
  static const _SETTINGS_KEY = '_SETTINGS_KEY';

  Future<Settings> getSettings() async {
    String? mJson = await PreferencesHelper.getString(_SETTINGS_KEY);
    if (mJson == null) {
      await setSettings(Settings.defaultSettings());
      return getSettings();
    }
    try {
      return Settings.fromJson(json.decode(mJson));
    } catch (e) {
      await setSettings(Settings.defaultSettings());
      return getSettings();
    }
    return Settings.fromJson(json.decode(mJson));
  }

  Future<void> setSettings(Settings settings) =>
      PreferencesHelper.setString(_SETTINGS_KEY, json.encode(settings.toJson()));

  Future<void> clearSettings() => PreferencesHelper.setString(_SETTINGS_KEY, null);
}
