// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilteredLog _$FilteredLogFromJson(Map<String, dynamic> json) => FilteredLog(
      logMessage: FilteredLog._logMessageFromJson(
          json['logMessage'] as Map<String, dynamic>),
      isSearchMatch: json['isSearchMatch'] as bool,
    );

Map<String, dynamic> _$FilteredLogToJson(FilteredLog instance) =>
    <String, dynamic>{
      'logMessage': FilteredLog._logMessageToJson(instance.logMessage),
      'isSearchMatch': instance.isSearchMatch,
    };
