import 'package:nekosama/src/config.dart';
import 'package:nekosama/src/extensions/iterable.dart';

/// All statuses available on `neko-sama.fr`.
enum NSStatuses {
  aired("2", "terminé"),
  airing("1", "en cours"),
  planned("0", "pas encore commencé");

  /// The name used internally by the website.
  final String apiName;

  /// The name displayed on the website.
  final String displayName;

  const NSStatuses(this.apiName, this.displayName);

  /// The url of this status.
  Uri get url => Uri.https(NSConfig.host, '/anime/#{"status":["$apiName"]}');

  /// Contruct a [NSStatuses] from a `String`.
  ///
  /// Returns `null` if [value] is not valid.
  static NSStatuses? fromString(String value) {
    final name = value.trim().toLowerCase();
    return NSStatuses.values.firstWhereOrNull((e) => [e.name, e.apiName, e.displayName].contains(name));
  }
}
