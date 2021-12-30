import 'package:flutter_socket_log_client/domain/models/communication.pb.dart';

import 'home_state.dart';

class MessagesState extends HomeState {
  final int tabId;
  final List<LogMessage> messages;

  MessagesState({
    required this.tabId,
    required this.messages,
  });

  @override
  List<Object?> get props => [];
}
