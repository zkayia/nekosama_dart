
import 'package:nekosama_dart/src/models/ns_episode.dart';

class NSNewEpisode extends NSEpisode {

	final DateTime addedAt;
	final String episodeTitle;
	
	NSNewEpisode({
		required super.animeId,
		required super.episodeNumber,
		required super.thumbnail,
		required super.url,
		required this.addedAt,
		required this.episodeTitle,
	});

	@override
	NSNewEpisode copyWith({
		int? animeId,
		int? episodeNumber,
		Uri? thumbnail,
		Uri? url,
		DateTime? addedAt,
		String? episodeTitle,
	}) => NSNewEpisode(
		animeId: animeId ?? this.animeId,
		episodeNumber: episodeNumber ?? this.episodeNumber,
		thumbnail: thumbnail ?? this.thumbnail,
		url: url ?? this.url,
		addedAt: addedAt ?? this.addedAt,
		episodeTitle: episodeTitle ?? this.episodeTitle,
	);

	@override
	String toString() => "NSDatedEpisode(animeId: $animeId, episodeNumber: $episodeNumber, thumbnail: $thumbnail, url: $url, addedAt: $addedAt, episodeTitle: $episodeTitle)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is NSNewEpisode
			&& other.animeId == animeId
			&& other.episodeNumber == episodeNumber
			&& other.thumbnail == thumbnail
			&& other.url == url
			&& other.addedAt == addedAt
			&& other.episodeTitle == episodeTitle;
	}

	@override
	int get hashCode => animeId.hashCode
		^ episodeNumber.hashCode
		^ thumbnail.hashCode
		^ url.hashCode
		^ addedAt.hashCode
		^ episodeTitle.hashCode;
}
