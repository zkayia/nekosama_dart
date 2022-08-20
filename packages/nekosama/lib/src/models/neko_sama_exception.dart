

class NekoSamaException implements Exception {

  final String message;

  NekoSamaException(this.message) : super();

  @override
  String toString() => "NekoSamaException: $message";
}
