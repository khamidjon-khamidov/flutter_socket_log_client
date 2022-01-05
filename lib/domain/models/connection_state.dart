class SocketConnectionState {
  final int _state;

  SocketConnectionState._(this._state);

  static SocketConnectionState connected = SocketConnectionState._(1);

  static SocketConnectionState loading = SocketConnectionState._(2);

  static SocketConnectionState disconnected = SocketConnectionState._(3);

  bool get isConnected => _state == 1;

  bool get isLoading => _state == 2;

  bool get isDisconnected => _state == 3;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocketConnectionState && runtimeType == other.runtimeType && _state == other._state;

  @override
  int get hashCode => _state.hashCode;
}
