import 'dart:convert';
import 'dart:io';

import 'package:nekosama/src/models/ns_exception.dart';

extension UriX on Uri {
  static Uri? tryParseNull(String? uri, [int start = 0, int? end]) {
    try {
      if (uri == null) {
        return null;
      }
      return Uri.tryParse(uri, start, end);
    } on FormatException {
      return null;
    }
  }

  Future<String> get({
    required HttpClient httpClient,
    Map<String, dynamic>? headers,
    bool? preserveHeaderCase,
  }) async {
    try {
      final request = await httpClient.getUrl(this)
        ..followRedirects = false
        ..persistentConnection = false;
      if (headers != null) {
        for (final header in headers.entries) {
          request.headers.add(
            header.key,
            header.value,
            preserveHeaderCase: preserveHeaderCase ?? false,
          );
        }
      }
      final response = await request.close();
      return response.transform(utf8.decoder).join();
    } on Exception catch (e) {
      throw NSNetworkException("Failed to get uri", e, toString());
    }
  }
}
