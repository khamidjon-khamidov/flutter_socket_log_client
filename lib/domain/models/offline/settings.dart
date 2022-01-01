import 'package:flutter_socket_log_client/domain/models/offline/tab.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable(explicitToJson: true)
class Settings {
  String appName;
  String ip;
  Set<SingleTab> tabs;

  void setAppName(String appName) => this.appName = appName;

  void setIp(String ip) => this.ip = ip;

  void setTab(Set<SingleTab> tabs) => this.tabs = tabs;

  factory Settings.defaultSettings() => Settings(
        '',
        '',
        {SingleTab.defaultTab()},
      );

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  Settings(
    this.appName,
    this.ip,
    this.tabs,
  );
}
