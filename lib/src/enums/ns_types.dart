import 'package:nekosama/src/config.dart';
import 'package:nekosama/src/extensions/iterable.dart';

/// All types available on `neko-sama.fr`.
enum NSTypes {
  movie("m0v1e", "film"),
  music("music", "music"),
  ona("ona", "ona"),
  ova("ova", "oav"),
  special("special", "special"),
  tv("tv", "tv"),
  tvShort("tv_short", "tv short");

  /// The name used internally by the website.
  final String apiName;

  /// The name displayed on the website.
  final String displayName;

  const NSTypes(this.apiName, this.displayName);

  /// The url of this type.
  Uri get url => Uri.https(NSConfig.host, '/anime/#{"type":["$apiName"]}');

  /// Contruct a `NSTypes` from a `String`.
  ///
  /// Returns `null` if [value] is not valid.
  static NSTypes? fromString(String value) {
    final name = value.trim().toLowerCase();
    return NSTypes.values.firstWhereOrNull((e) => [e.name, e.apiName, e.displayName].contains(name));
  }
}
