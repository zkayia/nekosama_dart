

/// All statuses available on `neko-sama.fr`.
enum NSStatuses {
  
  aired("2", "aired", "terminé"),
  airing("1", "airing", "en cours"),
  planned("0", "planned", "pas encore commencé");
  
  /// The name used internally by the website.
  final String apiName;
  /// The english name.
  final String englishName;
  /// The french name.
  final String frenchName;

  const NSStatuses(this.apiName, this.englishName, this.frenchName);

  /// The url of this status.
  Uri get url => Uri.parse('https://neko-sama.fr/anime/#{"status":["$apiName"]}');

  /// Contruct a [NSStatuses] from a `String`.
  /// 
  /// Returns `null` if [status] is not a valid value.
  static NSStatuses? fromString(String status) {
    final name = status.trim().toLowerCase();
    for (final status in NSStatuses.values) {
      if ([status.apiName, status.name, status.frenchName].contains(name)) {
        return status;
      }
    }
    return null;
  }
}
