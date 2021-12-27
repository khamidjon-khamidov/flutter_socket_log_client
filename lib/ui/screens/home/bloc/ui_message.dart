enum MessageType { error, success, warning, info }

class UIMessage {
  final MessageType messageType;
  final String message;

  UIMessage({
    required this.message,
    required this.messageType,
  });
}
