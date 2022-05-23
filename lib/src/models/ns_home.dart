
import 'package:collection/collection.dart';

import 'package:nekosama_dart/src/models/ns_carousel_anime.dart';
import 'package:nekosama_dart/src/models/ns_dated_episode.dart';

class NSHome {

	final List<NSNewEpisode> newEpisodes;
	final List<NSCarouselAnime> seasonalAnimes;
	final List<NSCarouselAnime> mostPopularAnimes;
	
	NSHome({
		required this.newEpisodes,
		required this.seasonalAnimes,
		required this.mostPopularAnimes,
	});

	NSHome copyWith({
		List<NSNewEpisode>? newEpisodes,
		List<NSCarouselAnime>? seasonalAnimes,
		List<NSCarouselAnime>? mostPopularAnimes,
	}) => NSHome(
		newEpisodes: newEpisodes ?? this.newEpisodes,
		seasonalAnimes: seasonalAnimes ?? this.seasonalAnimes,
		mostPopularAnimes: mostPopularAnimes ?? this.mostPopularAnimes,
	);

	@override
	String toString() => "NSHome(newEpisodes: $newEpisodes, seasonalAnimes: $seasonalAnimes, mostPopularAnimes: $mostPopularAnimes)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		final listEquals = const DeepCollectionEquality().equals;
		return other is NSHome && listEquals(other.newEpisodes, newEpisodes) && listEquals(other.seasonalAnimes, seasonalAnimes) && listEquals(other.mostPopularAnimes, mostPopularAnimes);
	}

	@override
	int get hashCode => newEpisodes.hashCode ^ seasonalAnimes.hashCode ^ mostPopularAnimes.hashCode;
}
