abstract class ChangeHighlightedMessageType {}

class MoveToPrevious extends ChangeHighlightedMessageType {}

class MoveToNext extends ChangeHighlightedMessageType {}

class MoveToMessage extends ChangeHighlightedMessageType {
  final int index;

  MoveToMessage(this.index);
}
