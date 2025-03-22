import 'package:nekosama/src/config.dart';
import 'package:nekosama/src/extensions/iterable.dart';

/// All genres available on `neko-sama.fr`.
enum NSGenres {
  action("action", "action"),
  adventure("adventure", "aventure"),
  battleRoyale("battle royale", "battle royale"),
  comedy("c0m1dy", "comédie"),
  cyberpunk("cyberpunk", "cyberpunk"),
  drama("drama", "drama"),
  ecchi("ecchi", "ecchi"),
  fantasy("fantasy", "fantastique"),
  hentai("hentai", "hentai"),
  horror("horror", "horreur"),
  isekai("isekai", "isekai"),
  mafia("mafia", "mafia"),
  magic("magic", "magique"),
  magicalGirl("mahou shoujo", "magical girl"),
  mecha("mecha", "mecha"),
  military("military", "militaire"),
  music("music", "musique"),
  mystery("mystery", "mystère"),
  psychological("psychological", "psychologique"),
  romance("romance", "romance"),
  sciFi("sci-fi", "sci-fi"),
  sliceOfLife("slice of life", "tranche de vie"),
  sports("sports", "sports"),
  supernatural("supernatural", "supernaturel"),
  thriller("thriller", "suspense");

  /// The name used internally by the website.
  final String apiName;

  /// The name displayed on the website.
  final String displayName;

  const NSGenres(this.apiName, this.displayName);

  /// The url of this genre.
  Uri get url => Uri.https(NSConfig.host, '/anime/#{"genres":["$apiName"]}');

  /// Contruct a [NSGenres] from a `String`.
  ///
  /// Returns `null` if [value] is not valid.
  static NSGenres? fromString(String value) {
    final name = value.trim().toLowerCase();
    return NSGenres.values.firstWhereOrNull((e) => [e.name, e.apiName, e.displayName].contains(name));
  }
}
