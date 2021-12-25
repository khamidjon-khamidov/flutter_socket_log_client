import 'package:flutter_socket_log_client/base/preferences_helper.dart';
import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

class SettingsProvider {
  static const _SETTINGS_KEY = '_SETTINGS_KEY';

  Future<Settings?> getSettings() async {
    String? json = await PreferencesHelper.getString(_SETTINGS_KEY);
    if (json == null) {
      return null;
    }
    return Settings.fromJson(json);
  }

  Future<void> setSettings(Settings settings) =>
      PreferencesHelper.setString(_SETTINGS_KEY, settings.writeToJson());
}
