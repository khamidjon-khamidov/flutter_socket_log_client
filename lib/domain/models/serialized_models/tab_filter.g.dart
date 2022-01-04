// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TabFilter _$TabFilterFromJson(Map<String, dynamic> json) => TabFilter(
      json['search'] as String,
      json['showOnlySearches'] as bool,
      tags: TabFilter._logTagFromJson(json['tags'] as Map<String, dynamic>),
      logLevels: TabFilter._logLevelFromJson(
          json['logLevels'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TabFilterToJson(TabFilter instance) => <String, dynamic>{
      'search': instance.search,
      'tags': TabFilter._logTagToJson(instance.tags),
      'logLevels': TabFilter._logLevelToJson(instance.logLevels),
      'showOnlySearches': instance.showOnlySearches,
    };
