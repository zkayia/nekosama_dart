
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:nekosama_dart/src/enums/enums_db_adaptors.dart';
import 'package:nekosama_dart/src/enums/ns_genres.dart';
import 'package:nekosama_dart/src/enums/ns_sources.dart';
import 'package:nekosama_dart/src/enums/ns_statuses.dart';
import 'package:nekosama_dart/src/enums/ns_types.dart';
import 'package:nekosama_dart/src/models/ns_anime_extended.dart';
import 'package:nekosama_dart/src/models/ns_titles.dart';


class NSSearchAnime extends NSAnimeExtended {

	final int year;
	
	NSSearchAnime({
		required super.id,
		required super.title,
		required super.titles,
		required super.genres,
		required super.source,
		required super.status,
		required super.type,
		required super.popularity,
		required super.score,
		required super.url,
		required super.thumbnail,
		required super.episodeCount,
		required this.year,
	});

	NSSearchAnime copyWith({
		int? id,
		String? title,
		NSTitles? titles,
		List<NSGenres>? genres,
		NSSources? source,
		NSStatuses? status,
		NSTypes? type,
		double? popularity,
		double? score,
		String? url,
		String? thumbnail,
		int? episodeCount,
		int? year,
	}) => NSSearchAnime(
		id: id ?? this.id,
		title: title ?? this.title,
		titles: titles ?? this.titles,
		genres: genres ?? this.genres,
		source: source ?? this.source,
		status: status ?? this.status,
		type: type ?? this.type,
		popularity: popularity ?? this.popularity,
		score: score ?? this.score,
		url: url ?? this.url,
		thumbnail: thumbnail ?? this.thumbnail,
		episodeCount: episodeCount ?? this.episodeCount,
		year: year ?? this.year,
	);

	Map<String, dynamic> toMap() => {
		"id": id,
		"title": title,
		"titles": titles.toMap(),
		"genres": genres.map((x) => enumToDb(x)).toList(),
		"source": enumToDb(source),
		"status": enumToDb(status),
		"type": enumToDb(type),
		"year": year,
		"popularity": popularity,
		"score": score,
		"url": url,
		"thumbnail": thumbnail,
		"episodeCount": episodeCount,
	};

	factory NSSearchAnime.fromMap(Map<String, dynamic> map) => NSSearchAnime(
		id: map["id"] ?? 0,
		title: map["title"] ?? "",
		titles: NSTitles.fromMap(map["titles"]),
		genres: List<NSGenres>.from(map["genres"]?.map((x) => enumFromDb(NSGenres.values, x))),
		source: enumFromDb(NSSources.values, map["source"]),
		status: enumFromDb(NSStatuses.values, map["status"]),
		type: enumFromDb(NSTypes.values, map["type"]),
		year: map["year"] ?? 0,
		popularity: map["popularity"] ?? 0.0,
		score: map["score"] ?? 0.0,
		url: map["url"] ?? "",
		thumbnail: map["thumbnail"] ?? "",
		episodeCount: map["episodeCount"] ?? 0,
	);

	String toJson() => json.encode(toMap());

	factory NSSearchAnime.fromJson(String source) => NSSearchAnime.fromMap(json.decode(source));

	@override
	String toString() =>
		"NSSearchAnime(id: $id, title: $title, titles: $titles, genres: $genres, source: $source, status: $status, type: $type, year: $year, popularity: $popularity, score: $score, url: $url, thumbnail: $thumbnail, episodeCount: $episodeCount)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		final listEquals = const DeepCollectionEquality().equals;
		return other is NSSearchAnime
			&& other.id == id
			&& other.title == title
			&& other.titles == titles
			&& listEquals(other.genres, genres)
			&& other.source == source
			&& other.status == status
			&& other.type == type
			&& other.year == year
			&& other.popularity == popularity
			&& other.score == score
			&& other.url == url
			&& other.thumbnail == thumbnail
			&& other.episodeCount == episodeCount;
	}

	@override
	int get hashCode => id.hashCode
		^ title.hashCode
		^ titles.hashCode
		^ genres.hashCode
		^ source.hashCode
		^ status.hashCode
		^ type.hashCode
		^ year.hashCode
		^ popularity.hashCode
		^ score.hashCode
		^ url.hashCode
		^ thumbnail.hashCode
		^ episodeCount.hashCode;
}
