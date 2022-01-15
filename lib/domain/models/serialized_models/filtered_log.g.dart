// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilteredLog _$FilteredLogFromJson(Map<String, dynamic> json) => FilteredLog(
      id: json['id'] as int,
      logMessage:
          LogMessage.fromJson(json['logMessage'] as Map<String, dynamic>),
      isSearchMatch: json['isSearchMatch'] as bool,
    );

Map<String, dynamic> _$FilteredLogToJson(FilteredLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logMessage': instance.logMessage.toJson(),
      'isSearchMatch': instance.isSearchMatch,
    };
