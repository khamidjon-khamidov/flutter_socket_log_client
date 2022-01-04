// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      json['appName'] as String,
      json['ip'] as String,
      (json['tabs'] as List<dynamic>)
          .map((e) => SingleTab.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'appName': instance.appName,
      'ip': instance.ip,
      'tabs': instance.tabs.map((e) => e.toJson()).toList(),
    };
