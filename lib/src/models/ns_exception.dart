sealed class NSException implements Exception {
  final String message;
  final Object? initialException;

  const NSException(
    this.message,
    this.initialException,
  );

  @override
  String toString() => "$runtimeType: $message; $initialException";
}

class NSNetworkException extends NSException {
  final String? url;

  const NSNetworkException(
    super.message,
    super.initialException,
    this.url,
  );

  @override
  String toString() => "$runtimeType: $message; $url; $initialException";
}

class NSParseException extends NSException {
  final Object? data;

  const NSParseException(
    super.message,
    super.initialException,
    this.data,
  );

  @override
  String toString() => "$runtimeType: $message; $data; $initialException";
}
