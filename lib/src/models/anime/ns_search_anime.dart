import 'dart:convert';

import 'package:nekosama/src/config.dart';
import 'package:nekosama/src/enums/ns_genres.dart';
import 'package:nekosama/src/enums/ns_sources.dart';
import 'package:nekosama/src/enums/ns_statuses.dart';
import 'package:nekosama/src/enums/ns_types.dart';
import 'package:nekosama/src/extensions/uri.dart';
import 'package:nekosama/src/models/anime/ns_anime_extended_base.dart';
import 'package:nekosama/src/models/anime/ns_anime_titles.dart';
import 'package:nekosama/src/utils.dart';

class NSSearchAnime extends NSAnimeExtendedBase {
  final int year;
  final double popularity;

  const NSSearchAnime({
    required super.id,
    required super.title,
    required super.titles,
    required super.genres,
    required super.source,
    required super.status,
    required super.type,
    required super.score,
    required super.url,
    required super.thumbnail,
    required super.episodeCount,
    required this.year,
    required this.popularity,
  });

  @override
  List<Object?> get props => [...super.props, year, popularity];

  NSSearchAnime copyWith({
    int? id,
    String? title,
    NSAnimeTitles? titles,
    List<NSGenres>? genres,
    NSSources? source,
    NSStatuses? status,
    NSTypes? type,
    double? score,
    Uri? url,
    Uri? thumbnail,
    int? episodeCount,
    int? year,
    double? popularity,
  }) =>
      NSSearchAnime(
        id: id ?? this.id,
        title: title ?? this.title,
        titles: titles ?? this.titles,
        genres: genres ?? this.genres,
        source: source ?? this.source,
        status: status ?? this.status,
        type: type ?? this.type,
        score: score ?? this.score,
        url: url ?? this.url,
        thumbnail: thumbnail ?? this.thumbnail,
        episodeCount: episodeCount ?? this.episodeCount,
        year: year ?? this.year,
        popularity: popularity ?? this.popularity,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "titles": titles.toMap(),
        "genres": genres.map((x) => x.index).toList(),
        "source": source.index,
        "status": status.index,
        "type": type.index,
        "score": score,
        "url": url.toString(),
        "thumbnail": thumbnail.toString(),
        "episodeCount": episodeCount,
        "year": year,
        "popularity": popularity,
      };

  factory NSSearchAnime.fromMap(Map<String, dynamic> map) => NSSearchAnime(
        id: map["id"] ?? 0,
        title: map["title"] ?? "",
        titles: NSAnimeTitles.fromMap(map["titles"]),
        genres: List<NSGenres>.from(map["genres"]?.map((x) => NSGenres.values.elementAt(x))),
        source: NSSources.values.elementAt(map["source"]),
        status: NSStatuses.values.elementAt(map["status"]),
        type: NSTypes.values.elementAt(map["type"]),
        score: map["score"] ?? 0.0,
        url: UriX.tryParseNull(map["url"]) ?? Uri(),
        thumbnail: UriX.tryParseNull(map["thumbnail"]) ?? Uri(),
        episodeCount: map["episodeCount"] ?? 0,
        year: map["year"] ?? 0,
        popularity: map["popularity"] ?? 0.0,
      );

  String toJson() => json.encode(toMap());

  factory NSSearchAnime.fromJson(String source) => NSSearchAnime.fromMap(json.decode(source));

  factory NSSearchAnime.fromSearchDbMap(
    Map<String, dynamic> nsMap, {
    NSSources source = NSSources.vostfr,
  }) =>
      NSSearchAnime(
        id: nsMap["id"] ?? 0,
        title: nsMap["title"] ?? "",
        titles: NSAnimeTitles.fromMap({
          "animeId": nsMap["id"] ?? 0,
          "english": nsMap["title_english"],
          "romanji": nsMap["title_romanji"],
          "french": nsMap["title_french"],
          "others": nsMap["others"],
        }),
        genres: [
          for (final e in (nsMap["genres"] as List?) ?? []) NSGenres.fromString(e),
        ].whereType<NSGenres>().toList(),
        source: source,
        status: NSStatuses.fromString(nsMap["status"] ?? "") ?? NSStatuses.aired,
        type: NSTypes.fromString(nsMap["type"] ?? "") ?? NSTypes.tv,
        year: int.tryParse(nsMap["start_date_year"] ?? "0") ?? 0,
        popularity: switch (nsMap["popularity"]) {
          final double popularity => popularity,
          final int popularity => popularity.toDouble(),
          _ => 0.0
        },
        score: double.tryParse(nsMap["score"] ?? "0.0") ?? 0.0,
        url: UriX.tryParseNull(nsMap["url"]) ?? Uri(),
        thumbnail: Uri.https(NSConfig.host, nsMap["url_image"]),
        episodeCount: NSUtils.extractEpisodeInt(nsMap["nb_eps"] ?? "0"),
      );
}
