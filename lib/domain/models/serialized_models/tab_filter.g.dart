// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TabFilter _$TabFilterFromJson(Map<String, dynamic> json) => TabFilter(
      json['search'] as String,
      json['showOnlySearches'] as bool,
      tags: (json['tags'] as List<dynamic>)
          .map((e) => LogTag.fromJson(e as Map<String, dynamic>))
          .toSet(),
      logLevels: (json['logLevels'] as List<dynamic>)
          .map((e) => LogLevel.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$TabFilterToJson(TabFilter instance) => <String, dynamic>{
      'search': instance.search,
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'logLevels': instance.logLevels.map((e) => e.toJson()).toList(),
      'showOnlySearches': instance.showOnlySearches,
    };
