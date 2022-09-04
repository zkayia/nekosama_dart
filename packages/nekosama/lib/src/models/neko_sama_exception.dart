

class NekoSamaException implements Exception {

  final String message;
  final Object? exception;

  NekoSamaException(this.message, [this.exception]) : super();

  @override
  String toString() => "NekoSamaException: $message; $exception.";
}
