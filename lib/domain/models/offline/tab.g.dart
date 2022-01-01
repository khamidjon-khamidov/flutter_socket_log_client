// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleTab _$SingleTabFromJson(Map<String, dynamic> json) => SingleTab(
      json['name'] as String,
      id: json['id'] as int,
      filter: TabFilter.fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SingleTabToJson(SingleTab instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'filter': instance.filter.toJson(),
    };
