import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart' as html;
import 'package:nekosama/src/config.dart';
import 'package:nekosama/src/enums/ns_genres.dart';
import 'package:nekosama/src/enums/ns_sources.dart';
import 'package:nekosama/src/enums/ns_statuses.dart';
import 'package:nekosama/src/enums/ns_types.dart';
import 'package:nekosama/src/extensions/uri.dart';
import 'package:nekosama/src/models/anime/ns_anime.dart';
import 'package:nekosama/src/models/episode/ns_episode.dart';
import 'package:nekosama/src/models/ns_exception.dart';
import 'package:nekosama/src/models/ns_home.dart';
import 'package:nekosama/src/models/anime/ns_search_anime.dart';
import 'package:nekosama/src/models/anime/ns_anime_titles.dart';
import 'package:nekosama/src/models/ns_website_info.dart';
import 'package:nekosama/src/utils.dart';

/// The main api for the `nekosama` library.
class NekoSama {
  /// An optional `HttpClient` to use to make requests.
  final HttpClient httpClient;

  /// The main api for the `nekosama` library.
  NekoSama({HttpClient? httpClient}) : httpClient = httpClient ?? HttpClient();

  /// Closes the HttpClient. Do not use this instance after call.
  void dispose() => httpClient.close(force: true);

  /// Gets the home page.
  Future<NSHome> getHome() async {
    final homePageResponse = await Uri.https(NSConfig.host).get(httpClient: httpClient);
    final responseTime = DateTime.now();
    final document = html.parse(homePageResponse);
    final carousels = document.getElementsByClassName("row anime-listing");
    return NSHome(
      newEpisodes: NSUtils.extractNewEpisodes(homePageResponse, responseTime),
      seasonalAnimes: NSUtils.parseCarousel(carousels.first),
      mostPopularAnimes: NSUtils.parseCarousel(carousels.last),
      websiteInfos: [
        ...document.querySelectorAll("#home .container > div:not([class])").map(
          (e) {
            final parts = e.text.split("-");
            final date = parts.first.trim().split("/").map(int.parse);
            return NSWebsiteInfo(
              date: DateTime(
                date.last,
                date.elementAt(1),
                date.first,
              ),
              message: parts.last.trim(),
              raw: e.text,
            );
          },
        ),
      ],
    );
  }

  /// Gets an [NSAnime] from it's url.
  Future<NSAnime> getAnime(Uri url) async {
    final animePageBody = await url
        .get(httpClient: httpClient)
        .onError((e, s) => throw NSNetworkException("Failed to fetch anime", e, url.toString()));
    try {
      return extractAnime(url, animePageBody);
    } on NSException {
      rethrow;
    } on Exception catch (e) {
      throw NSParseException("Failed to parse anime", e, (url, animePageBody));
    }
  }

  /// Extracts an [NSAnime] from the url and page body.
  NSAnime extractAnime(Uri url, String body) {
    try {
      final document = html.parse(body);
      final id = NSUtils.extractAnimeId(url);
      final title = document.getElementsByTagName("h1").first;
      final infos = document.getElementById("anime-info-list")?.children;
      final synopsisRaw = document.querySelector(".synopsis > p")?.text.trim();
      final synopsis =
          synopsisRaw == null || synopsisRaw.toLowerCase().contains("aucun synopsis pour le moment") ? null : synopsisRaw;
      // final rawEps = RegExp(r"(?<=var\sepisodes\s=\s)\[.+\](?=;)").firstMatch(body)?.group(0);
      // final episodes = [
      //   if (rawEps != null)
      //     for (final Map<String, dynamic> episode in jsonDecode(rawEps))
      //       NSEpisode(
      //         animeId: id,
      //         animeUrl: url,
      //         episodeNumber: NSUtils.extractEpisodeInt(episode["episode"]) ?? 0,
      //         thumbnail: UriX.tryParseNull(episode["url_image"]) ?? Uri(),
      //         url: Uri.https(NSConfig.host, episode["url"] ?? ""),
      //         duration: NSUtils.parseEpisodeDuration(episode["time"]),
      //       ),
      // ];
      final episodes = [
        for (final episode in document.querySelectorAll(".episodes a"))
          NSEpisode(
            episodeNumber: int.tryParse(episode.text.split(" ").last) ?? 0,
            url: UriX.tryParseNull(episode.attributes["href"]) ?? Uri(),
          ),
      ];
      final dates = infos?.last.text.split("-");
      return NSAnime(
        id: id,
        title: title.firstChild?.text?.replaceAll("VOSTFR", "").replaceAll("VF", "").trim() ?? "",
        url: url,
        thumbnail: UriX.tryParseNull(document.querySelector(".cover > img")?.attributes["src"]) ?? Uri(),
        episodeCount: NSUtils.extractEpisodeInt(infos?.elementAt(3).text ?? "?"),
        titles: NSAnimeTitles(others: title.nextElementSibling?.text.replaceAll("VOSTFR", "").replaceAll("VF", "").trim()),
        genres: [
          for (final e in document.getElementsByClassName("tag list").first.children) NSGenres.fromString(e.text),
        ].whereType<NSGenres>().toList(),
        source: NSUtils.extractAnimeSource(url.toString()),
        status: NSStatuses.fromString(
              RegExp(r"^\s\w+(.+)").firstMatch(infos?.elementAt(2).text ?? "")?.group(1) ?? "",
            ) ??
            NSStatuses.aired,
        type: NSTypes.fromString(
              RegExp(r"^\s\w+(.+)").firstMatch(infos?.elementAt(1).text ?? "")?.group(1) ?? "",
            ) ??
            NSTypes.tv,
        score: double.tryParse(
              RegExp(r"(\d+\.?\d*)\/5").firstMatch(infos?.first.text ?? "")?.group(1) ?? "",
            ) ??
            0.0,
        synopsis: synopsis,
        episodes: episodes,
        startDate: NSUtils.extractDate(dates?.first ?? ""),
        endDate: NSUtils.extractDate(dates?.last ?? ""),
      );
    } on NSException {
      rethrow;
    } on Exception catch (e) {
      throw NSParseException("Failed to extract anime", e, (url, body));
    }
  }

  /// Gets the urls of the video player embeds for [episodeUrl].
  ///
  /// Returns an empty list if no video is found.
  Future<List<Uri>> getVideoUrls(Uri episodeUrl) async {
    final response = await episodeUrl
        .get(httpClient: httpClient)
        .onError((e, s) => throw NSNetworkException("Failed to fetch episode", e, episodeUrl.toString()));
    try {
      return [
        ...RegExp(r"^\s*video\[\d+]\s*=\s*'(.+)';$", multiLine: true)
            .allMatches(response)
            .map((e) => UriX.tryParseNull((e.group(1)?.isNotEmpty ?? true) ? e.group(1)! : null))
            .whereType<Uri>(),
      ];
    } on Exception catch (e) {
      throw NSParseException("Failed to parse video urls", e, response);
    }
  }

  /// Gets the search db and parses it into a list of NSSearchAnime.
  ///
  /// [source] is used to choose the database to fetch.
  ///
  /// See [getRawSearchDb] for more.
  Future<List<NSSearchAnime>> getSearchDb([NSSources source = NSSources.vostfr]) async {
    final rawDb = await getRawSearchDb(source);
    try {
      return [...rawDb.map((e) => NSSearchAnime.fromSearchDbMap(e, source: source))];
    } on Exception catch (e) {
      throw NSParseException("Failed to build a NSSearchAnime from the search db", e, rawDb);
    }
  }

  /// Gets the search db, a json list of all animes.
  ///
  /// [source] is used to choose the database to fetch.
  ///
  /// Vostfr: https://neko-sama.fr/animes-search-vostfr.json
  ///
  /// Vf: https://neko-sama.fr/animes-search-vf.json
  Future<List<Map<String, dynamic>>> getRawSearchDb([NSSources source = NSSources.vostfr]) async {
    final uri = Uri.https(NSConfig.host, "/animes-search-${source.apiName}.json");
    final data = await uri
        .get(httpClient: httpClient)
        .onError((e, s) => throw NSNetworkException("Failed to fetch the search db", e, uri.toString()));
    try {
      return [...(jsonDecode(data) as List).whereType<Map<String, dynamic>>()];
    } on Exception catch (e) {
      throw NSParseException("Failed to parse the search db", e, data);
    }
  }

  Uri getSearchDbUrl([NSSources source = NSSources.vostfr]) => Uri.https(NSConfig.host, "/animes-search-${source.apiName}.json");
}
