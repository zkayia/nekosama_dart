
import 'package:nekosama/src/models/ns_episode.dart';

class NSNewEpisode extends NSEpisode {

	final DateTime addedAt;
	final String episodeTitle;
	
	NSNewEpisode({
		required super.animeId,
		required super.animeUrl,
		required super.episodeNumber,
		required super.thumbnail,
		required super.url,
		super.duration,
		required this.addedAt,
		required this.episodeTitle,
	});

	@override
	NSNewEpisode copyWith({
		int? animeId,
		Uri? animeUrl,
		int? episodeNumber,
		Uri? thumbnail,
		Uri? url,
		Duration? duration,
		DateTime? addedAt,
		String? episodeTitle,
	}) => NSNewEpisode(
		animeId: animeId ?? this.animeId,
		animeUrl: animeUrl ?? this.animeUrl,
		episodeNumber: episodeNumber ?? this.episodeNumber,
		thumbnail: thumbnail ?? this.thumbnail,
		url: url ?? this.url,
		duration: duration ?? this.duration,
		addedAt: addedAt ?? this.addedAt,
		episodeTitle: episodeTitle ?? this.episodeTitle,
	);

	@override
	String toString() => "NSDatedEpisode(animeId: $animeId, animeUrl: $animeUrl, episodeNumber: $episodeNumber, thumbnail: $thumbnail, url: $url, duration: $duration, addedAt: $addedAt, episodeTitle: $episodeTitle)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is NSNewEpisode
			&& other.animeId == animeId
			&& other.animeUrl == animeUrl
			&& other.episodeNumber == episodeNumber
			&& other.thumbnail == thumbnail
			&& other.url == url
			&& other.duration == duration
			&& other.addedAt == addedAt
			&& other.episodeTitle == episodeTitle;
	}

	@override
	int get hashCode => animeId.hashCode
		^ animeUrl.hashCode
		^ episodeNumber.hashCode
		^ thumbnail.hashCode
		^ url.hashCode
		^ duration.hashCode
		^ addedAt.hashCode
		^ episodeTitle.hashCode;
}
