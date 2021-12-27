enum MessageType { error, success, warning, info }

class UserMessage {
  final MessageType messageType;
  final String message;

  factory UserMessage.error(String message) => UserMessage._(
        message: message,
        messageType: MessageType.error,
      );

  factory UserMessage.info(String message) => UserMessage._(
        message: message,
        messageType: MessageType.info,
      );

  factory UserMessage.success(String message) => UserMessage._(
        message: message,
        messageType: MessageType.success,
      );

  factory UserMessage.warning(String message) => UserMessage._(
        message: message,
        messageType: MessageType.warning,
      );

  UserMessage._({
    required this.message,
    required this.messageType,
  });
}
