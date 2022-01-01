import 'package:flutter_socket_log_client/domain/models/offline/tab_filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tab.g.dart';

@JsonSerializable(explicitToJson: true)
class SingleTab {
  final int id;
  String name;
  TabFilter filter;

  void setName(String name) => this.name = name;

  factory SingleTab.defaultTab() => SingleTab(
        'All',
        id: 0,
        filter: TabFilter.defaultFilter(),
      );

  factory SingleTab.fromJson(Map<String, dynamic> json) => _$SingleTabFromJson(json);

  Map<String, dynamic> toJson() => _$SingleTabToJson(this);

  SingleTab(
    this.name, {
    required this.id,
    required this.filter,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SingleTab && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
