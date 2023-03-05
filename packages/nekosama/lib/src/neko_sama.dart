
import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:nekosama/nekosama.dart';
import 'package:nekosama/src/helpers/extract_anime_id.dart';
import 'package:nekosama/src/helpers/extract_anime_source.dart';
import 'package:nekosama/src/helpers/extract_episode_int.dart';
import 'package:nekosama/src/helpers/extract_date.dart';
import 'package:nekosama/src/helpers/extract_new_episodes.dart';
import 'package:nekosama/src/extensions/uri_get.dart';
import 'package:nekosama/src/helpers/parse_carousel.dart';
import 'package:nekosama/src/helpers/parse_episode_duration.dart';


/// The main api for the `nekosama` library.
class NekoSama {
  
  /// An optional `HttpClient` to use to make requests.
  final HttpClient httpClient;

  /// The main api for the `nekosama` library.
  NekoSama({HttpClient? httpClient}) : httpClient = httpClient ?? HttpClient();

  // Closes the HttpClient. Do not use this instance after call.
  void dispose() => httpClient.close(force: true);

  /// Gets the home page.
  Future<NSHome> getHome() async {
    final homePageResponse = await Uri.https("neko-sama.fr", "").get(httpClient: httpClient);
    final carousels = parse(homePageResponse.body).getElementsByClassName("row anime-listing");
    return NSHome(
      newEpisodes: extractNewEpisodes(homePageResponse),
      seasonalAnimes: parseCarousel(carousels.first),
      mostPopularAnimes: parseCarousel(carousels.last),
    );
  }

  /// Gets an [NSAnime] from it's url.
  Future<NSAnime> getAnime(Uri url) async {
    try {
      final animePageBody = (await url.get(httpClient: httpClient)).body;
      final document = parse(animePageBody);
      final id = extractAnimeId(url);
      final title = document.getElementsByTagName("h1").first;
      final infos = document.getElementById("anime-info-list")?.children;
      final synopsisRaw = document.querySelector(".synopsis > p")?.text.trim();
      final synopsis = synopsisRaw == null || synopsisRaw.toLowerCase().contains("aucun synopsis pour le moment")
        ? null
        : synopsisRaw;
      final episodes = (await _getEpisodes(id, url, animePageBody)) ?? [];
      final dates = infos?.last.text.split("-");
      return NSAnime(
        id: id,
        title: title.firstChild?.text?.replaceAll("VOSTFR", "").trim() ?? "",
        url: url,
        thumbnail: Uri.tryParse(document.querySelector(".cover > img")?.attributes["src"] ?? "::Not valid URI::") ?? Uri(),
        episodeCount: extractEpisodeInt(infos?.elementAt(3).text ?? "?"),
        titles: NSTitles(
          animeId: id,
          others: title.nodes.last.text,
        ),
        genres: [
          for (final e in document.getElementsByClassName("tag list").first.children)
            NSGenres.fromString(
              RegExp(r"\[\W+([\w\s\-]+)\W").firstMatch(e.attributes["href"] ?? "")?.group(1) ?? "",
            ),
        ].whereType<NSGenres>().toList(),
        source: extractAnimeSource(url.toString()),
        status: NSStatuses.fromString(
          RegExp(r"^\s\w+(.+)").firstMatch(infos?.elementAt(2).text ?? "")?.group(1) ?? "",
        ) ?? NSStatuses.aired,
        type: NSTypes.fromString(
          RegExp(r"^\s\w+(.+)").firstMatch(infos?.elementAt(1).text ?? "")?.group(1) ?? "",
        ) ?? NSTypes.tv,
        score: double.tryParse(
          RegExp(r"(\d+\.?\d*)\/5").firstMatch(infos?.first.text ?? "")?.group(1) ?? "",
        ) ?? 0.0,
        synopsis: synopsis,
        episodes: episodes,
        startDate: extractDate(dates?.first ?? ""),
        endDate: extractDate(dates?.last ?? ""),
      );
    } on Exception catch (e) {
      throw NekoSamaException("Failed to get anime at url '$url'", e);
    }
  }

  /// Tries to guess the episode urls of [anime].
  /// 
  /// Provided as a request-free alternative to [getEpisodes].
  /// 
  /// Guessed urls are not guaranteed to be correct.
  /// 
  /// If [anime] has 0 episodes, tries to fetch episodes and
  /// returns `null` if no episodes were found.
  Future<List<Uri>?> guessEpisodeUrls(NSAnimeBase anime) async {
    if (anime is NSAnime) {
      return [...anime.episodes.map((e) => e.url)];
    }
    if (anime.episodeCount == 0) {
      final eps = await _getEpisodes(anime.id, anime.url);
      return eps == null
        ? null
        : [...eps.map((e) => e.url)];
    }
    final baseUrl = anime.url
      .toString()
      .replaceFirst("/info/", "/episode/");
    return [
      for (var i = 1; i < anime.episodeCount+1; i++)
        Uri.parse(
          baseUrl.replaceFirst(
            RegExp("-${anime.source.apiName}\$"),
            "-${i.toString().padLeft(2, "0")}-${anime.source.apiName}",
          ),
        ),
    ];
  }

  /// Gets the [NSEpisode] list of [anime].
  /// 
  /// Set [force] to true to require a request.
  /// 
  /// Returns `null` if no episodes were found.
  Future<List<NSEpisode>?> getEpisodes(NSAnimeBase anime, {bool force=false}) async =>
    anime is NSAnime && !force
      ? anime.episodes
      : await _getEpisodes(
        anime.id,
        anime.url,
      );

  Future<List<NSEpisode>?> _getEpisodes(int animeId, Uri animeUrl, [String? animePageBody]) async {
    try {
      final rawEps = RegExp(r"(?<=var\sepisodes\s=\s)\[.+\](?=;)")
        .firstMatch(animePageBody ?? (await animeUrl.get(httpClient: httpClient)).body)?.group(0);
      if (rawEps == null) {
        return null;
      }
      return [
        for (final Map<String, dynamic> episode in jsonDecode(rawEps))
          NSEpisode(
            animeId: animeId,
            animeUrl: animeUrl,
            episodeNumber: extractEpisodeInt(episode["episode"]),
            thumbnail: Uri.tryParse(episode["url_image"] ?? "::Not valid URI::") ?? Uri(),
            url: Uri.parse("https://neko-sama.fr${episode["url"] ?? ""}"),
            duration: parseEpisodeDuration(episode["time"]),
          ),
      ];
    } on Exception catch (e) {
      throw NekoSamaException("Failed to parse episodes for anime at url '$animeUrl'", e);
    }
  }

  /// Gets the url of the video player embed of [episode].
  /// 
  /// Currently only supports episode videos hosted on `pstream.net`.
  @Deprecated("Use getVideoUrls instead")
  Future<Uri?> getVideoUrl(NSEpisode episode) async {
    try {
      return Uri.tryParse(
        RegExp(r"=\s'(https://www.pstream.net/e/.+)'")
          .firstMatch((await episode.url.get(httpClient: httpClient)).body,
        )?.group(1) ?? "::Not valid URI::",
      );
    } on Exception catch (e) {
      throw NekoSamaException("Failed to get the video link.", e);
    }
  }

  /// Gets the url of the video player embed of [episode].
  /// 
  /// Returns an empty list if no video is found.
  Future<List<Uri>> getVideoUrls(NSEpisode episode) async {
    try {
      return [
        ...RegExp(r"^\s*video\[\d+]\s*=\s*'(.+)';$", multiLine: true)
          .allMatches((await episode.url.get(httpClient: httpClient)).body)
          .map(
            (e) => Uri.tryParse(
              (e.group(1)?.isNotEmpty ?? true) ? e.group(1)! : "::Not valid URI::",
            ),
          )
          .whereType<Uri>(),
      ];
    } on Exception catch (e) {
      throw NekoSamaException("Failed to get video players.", e);
    }
  }

  /// Gets the search db and parses it into a list of NSSearchAnime.
  /// 
  /// [source] is used to choose the database to fetch.
  /// 
  /// See [getRawSearchDb] for more.
  Future<List<NSSearchAnime>> getSearchDb([NSSources source=NSSources.vostfr]) async {
    try {
      return [
        ...(await getRawSearchDb(source)).map(
          (e) => NSSearchAnime.fromSearchDbMap(e, source: source),
        ),
      ];
    } on NekoSamaException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw NekoSamaException("Failed to build a NSSearchAnime from the search db", e);
    }
  }

  /// Gets the search db, a json list of all animes.
  /// 
  /// [source] is used to choose the database to fetch.
  /// 
  /// Vostfr: https://neko-sama.fr/animes-search-vostfr.json
  /// 
  /// Vf: https://neko-sama.fr/animes-search-vf.json
  Future<List<Map<String, dynamic>>> getRawSearchDb([NSSources source=NSSources.vostfr]) async {
    try {
      return [
        ...(
          jsonDecode(
            (
              await Uri.https(
                "neko-sama.fr",
                "/animes-search-${source.apiName}.json",
              ).get(httpClient: httpClient)
            ).body,
          ) as List
        ).whereType<Map<String, dynamic>>()
      ];
    } on Exception catch (e) {
      throw NekoSamaException("Failed to fetch/parse the search db", e);
    }
  }
}
