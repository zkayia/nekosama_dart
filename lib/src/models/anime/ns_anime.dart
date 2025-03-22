import 'dart:convert';

import 'package:nekosama/src/enums/ns_genres.dart';
import 'package:nekosama/src/enums/ns_sources.dart';
import 'package:nekosama/src/enums/ns_statuses.dart';
import 'package:nekosama/src/enums/ns_types.dart';
import 'package:nekosama/src/extensions/uri.dart';
import 'package:nekosama/src/models/anime/ns_anime_extended_base.dart';
import 'package:nekosama/src/models/episode/ns_episode.dart';
import 'package:nekosama/src/models/anime/ns_anime_titles.dart';

class NSAnime extends NSAnimeExtendedBase {
  final String? synopsis;
  final List<NSEpisode> episodes;
  final DateTime? startDate;
  final DateTime? endDate;

  const NSAnime({
    required super.id,
    required super.title,
    required super.url,
    required super.thumbnail,
    required super.episodeCount,
    required super.titles,
    required super.genres,
    required super.source,
    required super.status,
    required super.type,
    required super.score,
    required this.synopsis,
    required this.episodes,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [...super.props, synopsis, episodes, startDate, endDate];

  NSAnime copyWith({
    int? id,
    String? title,
    Uri? url,
    Uri? thumbnail,
    int? episodeCount,
    NSAnimeTitles? titles,
    List<NSGenres>? genres,
    NSSources? source,
    NSStatuses? status,
    NSTypes? type,
    double? score,
    String? synopsis,
    List<NSEpisode>? episodes,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      NSAnime(
        id: id ?? this.id,
        title: title ?? this.title,
        url: url ?? this.url,
        thumbnail: thumbnail ?? this.thumbnail,
        episodeCount: episodeCount ?? this.episodeCount,
        titles: titles ?? this.titles,
        genres: genres ?? this.genres,
        source: source ?? this.source,
        status: status ?? this.status,
        type: type ?? this.type,
        score: score ?? this.score,
        synopsis: synopsis ?? this.synopsis,
        episodes: episodes ?? this.episodes,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "url": url.toString(),
        "thumbnail": thumbnail.toString(),
        "episodeCount": episodeCount,
        "titles": titles.toMap(),
        "genres": genres.map((x) => x.index).toList(),
        "source": source.index,
        "status": status.index,
        "type": type.index,
        "score": score,
        "synopsis": synopsis,
        "episodes": episodes.map((x) => x.toMap()).toList(),
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
      };

  factory NSAnime.fromMap(Map<String, dynamic> map) => NSAnime(
        id: map["id"] ?? 0,
        title: map["title"] ?? "",
        url: UriX.tryParseNull(map["url"]) ?? Uri(),
        thumbnail: UriX.tryParseNull(map["thumbnail"]) ?? Uri(),
        episodeCount: map["episodeCount"] ?? 0,
        titles: NSAnimeTitles.fromMap(map["titles"]),
        genres: List<NSGenres>.from(map["genres"]?.map((x) => NSGenres.values.elementAt(x))),
        source: NSSources.values.elementAt(map["source"]),
        status: NSStatuses.values.elementAt(map["status"]),
        type: NSTypes.values.elementAt(map["type"]),
        score: map["score"] ?? 0.0,
        synopsis: map["synopsis"],
        episodes: List<NSEpisode>.from(map["episodes"]?.map(NSEpisode.fromMap)),
        startDate: map["startDate"] != null ? DateTime.parse(map["startDate"]) : null,
        endDate: map["endDate"] != null ? DateTime.parse(map["endDate"]) : null,
      );

  String toJson() => json.encode(toMap());

  factory NSAnime.fromJson(String source) => NSAnime.fromMap(json.decode(source));
}
