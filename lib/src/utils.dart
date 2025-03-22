import 'dart:convert';

import 'package:html/dom.dart';
import 'package:nekosama/src/config.dart';
import 'package:nekosama/src/enums/ns_new_episode_icon.dart';
import 'package:nekosama/src/enums/ns_sources.dart';
import 'package:nekosama/src/extensions/uri.dart';
import 'package:nekosama/src/models/anime/ns_carousel_anime.dart';
import 'package:nekosama/src/models/ns_exception.dart';
import 'package:nekosama/src/models/episode/ns_new_episode.dart';

class NSUtils {
  const NSUtils._();

  static int extractAnimeId(Uri url) {
    final err = NSParseException("Unable to extract anime id", null, url);
    for (var i = 2; i < url.pathSegments.length; i++) {
      if (url.pathSegments[i - 2] == "anime" && url.pathSegments[i - 1] == "info") {
        return int.tryParse(
              RegExp(r"^(\d+)-")
                      .firstMatch(
                        url.pathSegments[i],
                      )
                      ?.group(1) ??
                  "",
            ) ??
            (throw err);
      }
    }
    throw err;
  }

  static NSSources extractAnimeSource(String url) =>
      NSSources.fromString(
        RegExp(r"(?<=_)(vf|vostfr)\b").firstMatch(url)?.group(0) ?? "",
      ) ??
      NSSources.vostfr;

  static const _months = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];
  static DateTime? extractDate(String date) {
    try {
      final dateFormatted = date.trim().toLowerCase();
      for (int i = 0; i < _months.length; i++) {
        if (dateFormatted.contains(_months.elementAt(i))) {
          final match = RegExp(r"\d+").firstMatch(dateFormatted)?.group(0);
          return match == null ? null : DateTime(int.parse(match), i + 1);
        }
      }
      return null;
    } on Exception catch (e) {
      throw NSParseException("Failed to extract date", e, date);
    }
  }

  static int? extractEpisodeInt(String episode) {
    final match = RegExp(r"\d+|film|\?").firstMatch(episode.toLowerCase())?.group(0);
    switch (match) {
      case "film":
        return 1;
      case "?":
      case null:
        return null;
      default:
        return int.parse(match);
    }
  }

  static List<NSNewEpisode> extractNewEpisodes(String homePageResponse, DateTime responseTime) {
    final reg = RegExp(r"(?<=var\slastEpisodes\s=\s)\[.+\](?=;)");
    final rawLastEps = reg.firstMatch(homePageResponse)?.group(0);
    return [
      if (rawLastEps != null)
        for (final Map<String, dynamic> episode in jsonDecode(rawLastEps))
          NSNewEpisode(
            episodeNumber: extractEpisodeInt(episode["episode"] ?? "0") ?? 0,
            url: Uri.https(NSConfig.host, episode["url"]),
            animeUrl: Uri.https(NSConfig.host, episode["anime_url"]),
            addedAt: DateTime.fromMillisecondsSinceEpoch((episode["timestamp"] ?? 0) * 1000),
            title: episode["title"] ?? "",
            thumbnail: Uri.https(NSConfig.host, episode["url_bg"]),
            animeThumbnail: Uri.https(NSConfig.host, episode["url_image"]),
            icons: [
              for (final icon in NSNewEpisodeIcon.values)
                if ((episode["icons"] as String?)?.toLowerCase().contains(">${icon.apiName}<") ?? false) icon,
            ],
          ),
    ];
  }

  static List<NSCarouselAnime> parseCarousel(Element carousel) {
    final carouselAnimes = <NSCarouselAnime>[];
    try {
      for (final carouselElement in carousel.children) {
        final url = UriX.tryParseNull(carouselElement.getElementsByTagName("a").first.attributes["href"]) ?? Uri();
        final data = carouselElement.getElementsByClassName("episode").first.text.split("-");
        carouselAnimes.add(
          NSCarouselAnime(
            id: extractAnimeId(url),
            title: carouselElement.getElementsByClassName("title").first.text,
            year: int.parse(data.first.trim()),
            url: url,
            source: extractAnimeSource(url.toString()),
            thumbnail: UriX.tryParseNull(carouselElement.getElementsByClassName("lazy").first.attributes["data-src"]) ?? Uri(),
            episodeCount: extractEpisodeInt(data.last.trim()),
          ),
        );
      }
      return carouselAnimes;
    } on Exception catch (e) {
      throw NSParseException("Unable to extract anime from carousel element", e, carousel);
    }
  }

  static Duration? parseEpisodeDuration(String duration) {
    final match = int.tryParse(RegExp(r"\d+").firstMatch(duration)?.group(0) ?? "");
    return match == null ? null : Duration(minutes: match);
  }
}
