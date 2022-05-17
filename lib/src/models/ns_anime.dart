
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:nekosama_dart/src/enums/enums_db_adaptors.dart';
import 'package:nekosama_dart/src/enums/ns_genres.dart';
import 'package:nekosama_dart/src/enums/ns_sources.dart';
import 'package:nekosama_dart/src/enums/ns_statuses.dart';
import 'package:nekosama_dart/src/enums/ns_types.dart';
import 'package:nekosama_dart/src/models/ns_titles.dart';


class NSAnime {

	final int id;
	final String title;
	final NSTitles titles;
	final List<NSGenres> genres;
	final NSStatuses status;
	final NSTypes type;
	final int year;
	final double popularity;
	final double score;
	final String url;
	final String thumbnail;
	final int episodeCount;

	
	NSAnime({
		required this.id,
		required this.title,
		required this.titles,
		required this.genres,
		required this.status,
		required this.type,
		required this.year,
		required this.popularity,
		required this.score,
		required this.url,
		required this.thumbnail,
		required this.episodeCount,
	});

	NSSources get source => NSSources.fromString(
		RegExp(r"-(\w+)$").firstMatch(url)?.group(1) ?? "",
	) ?? NSSources.vostfr;

	NSAnime copyWith({
		int? id,
		String? title,
		NSTitles? titles,
		List<NSGenres>? genres,
		NSStatuses? status,
		NSTypes? type,
		int? year,
		double? popularity,
		double? score,
		String? url,
		String? thumbnail,
		int? episodeCount,
	}) => NSAnime(
		id: id ?? this.id,
		title: title ?? this.title,
		titles: titles ?? this.titles,
		genres: genres ?? this.genres,
		status: status ?? this.status,
		type: type ?? this.type,
		year: year ?? this.year,
		popularity: popularity ?? this.popularity,
		score: score ?? this.score,
		url: url ?? this.url,
		thumbnail: thumbnail ?? this.thumbnail,
		episodeCount: episodeCount ?? this.episodeCount,
	);

	Map<String, dynamic> toMap() => {
		"id": id,
		"title": title,
		"titles": titles.toMap(),
		"genres": genres.map((x) => enumToDb(x)).toList(),
		"status": enumToDb(status),
		"type": enumToDb(type),
		"year": year,
		"popularity": popularity,
		"score": score,
		"url": url,
		"thumbnail": thumbnail,
		"episodeCount": episodeCount,
	};

	factory NSAnime.fromMap(Map<String, dynamic> map) => NSAnime(
		id: map["id"] ?? 0,
		title: map["title"] ?? "",
		titles: NSTitles.fromMap(map["titles"]),
		genres: List<NSGenres>.from(map["genres"]?.map((x) => enumFromDb(NSGenres.values, x))),
		status: enumFromDb(NSStatuses.values, map["status"]),
		type: enumFromDb(NSTypes.values, map["type"]),
		year: map["year"] ?? 0,
		popularity: map["popularity"] ?? 0.0,
		score: map["score"] ?? 0.0,
		url: map["url"] ?? "",
		thumbnail: map["thumbnail"] ?? "",
		episodeCount: map["episodeCount"] ?? "0",
	);

	String toJson() => json.encode(toMap());

	factory NSAnime.fromJson(String source) => NSAnime.fromMap(json.decode(source));

	@override
	String toString() =>
		"NSAnime(id: $id, title: $title, titles: $titles, genres: $genres, status: $status, type: $type, year: $year, popularity: $popularity, score: $score, url: $url, thumbnail: $thumbnail, episodeCount: $episodeCount)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		final listEquals = const DeepCollectionEquality().equals;
		return other is NSAnime
			&& other.id == id
			&& other.title == title
			&& other.titles == titles
			&& listEquals(other.genres, genres)
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
		^ status.hashCode
		^ type.hashCode
		^ year.hashCode
		^ popularity.hashCode
		^ score.hashCode
		^ url.hashCode
		^ thumbnail.hashCode
		^ episodeCount.hashCode;
}
