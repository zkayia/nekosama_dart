import 'package:nekosama/src/config.dart';
import 'package:nekosama/src/extensions/iterable.dart';

/// All sources available on `neko-sama.fr`.
enum NSSources {
  vf("vf"),
  vostfr("vostfr");

  /// The name used internally by the website.
  final String apiName;

  const NSSources(this.apiName);

  /// The name displayed on the website.
  String get displayName => apiName;

  /// The url of this source.
  Uri get url => Uri.https(NSConfig.host, "/anime${this == NSSources.vf ? "-vf" : ""}");

  /// Contruct a [NSSources] from a `String`.
  ///
  /// Returns `null` if [value] is not valid.
  static NSSources? fromString(String value) {
    final name = value.trim().toLowerCase();
    return NSSources.values.firstWhereOrNull((e) => [e.name, e.apiName].contains(name));
  }
}
