

class NSEpisode {

	final int animeId;
	final int episodeNumber;
	final String thumbnail;
	final String url;
	
	NSEpisode({
		required this.animeId,
		required this.episodeNumber,
		required this.thumbnail,
		required this.url,
	});

	NSEpisode copyWith({
		int? animeId,
		int? episodeNumber,
		String? thumbnail,
		String? url,
	}) => NSEpisode(
		animeId: animeId ?? this.animeId,
		episodeNumber: episodeNumber ?? this.episodeNumber,
		thumbnail: thumbnail ?? this.thumbnail,
		url: url ?? this.url,
	);

	@override
	String toString() =>
		"NSEpisode(animeId: $animeId, episodeNumber: $episodeNumber, thumbnail: $thumbnail, url: $url)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is NSEpisode
			&& other.animeId == animeId
			&& other.episodeNumber == episodeNumber
			&& other.thumbnail == thumbnail
			&& other.url == url;
	}

	@override
	int get hashCode => animeId.hashCode
		^ episodeNumber.hashCode
		^ thumbnail.hashCode
		^ url.hashCode;
}