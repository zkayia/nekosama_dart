

class NekoSamaException implements Exception {

  final String message;
  final Object? exception;

  NekoSamaException(String message, [Object? exception]) :
    message = "$message${exception is NekoSamaException ? " => ${exception.message}" : ""}",
    exception = exception is NekoSamaException ? exception.exception : exception,
    super();

  @override
  String toString() => "NekoSamaException: $message; $exception.";
}
