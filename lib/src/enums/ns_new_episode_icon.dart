import 'package:nekosama/src/extensions/iterable.dart';

/// Icons of new episodes in the home page.
enum NSNewEpisodeIcon {
  nc("nc", 0xffca00bd),
  vf("vf", 0xffd90000);

  /// The name used by the website.
  final String apiName;

  /// The icon color in hex format.
  final int hexColor;

  const NSNewEpisodeIcon(
    this.apiName,
    this.hexColor,
  );

  /// The name displayed on the website.
  String get displayName => apiName;

  /// Contruct a `NSNewEpisodeIcon` from a `String`.
  ///
  /// Returns `null` if [value] is not valid.
  static NSNewEpisodeIcon? fromString(String value) {
    final name = value.trim().toLowerCase();
    return NSNewEpisodeIcon.values.firstWhereOrNull((e) => [e.name, e.apiName].contains(name));
  }
}
