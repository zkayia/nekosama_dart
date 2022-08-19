import 'dart:convert';



class NSEpisode {

	final int animeId;
	final Uri animeUrl;
	final int episodeNumber;
	final Uri thumbnail;
	final Uri url;
	final Duration? duration;
	
	NSEpisode({
		required this.animeId,
		required this.animeUrl,
		required this.episodeNumber,
		required this.thumbnail,
		required this.url,
		this.duration,
	});

	NSEpisode copyWith({
		int? animeId,
		Uri? animeUrl,
		int? episodeNumber,
		Uri? thumbnail,
		Uri? url,
		Duration? duration,
	}) => NSEpisode(
		animeId: animeId ?? this.animeId,
		animeUrl: animeUrl ?? this.animeUrl,
		episodeNumber: episodeNumber ?? this.episodeNumber,
		thumbnail: thumbnail ?? this.thumbnail,
		url: url ?? this.url,
		duration: duration ?? this.duration,
	);

	Map<String, dynamic> toMap() => {
		"animeId": animeId,
		"animeUrl": animeUrl.toString(),
		"episodeNumber": episodeNumber,
		"thumbnail": thumbnail.toString(),
		"url": url.toString(),
		"duration": duration?.inMilliseconds,
	};

	factory NSEpisode.fromMap(Map<String, dynamic> map) => NSEpisode(
		animeId: map["animeId"] ?? 0,
		animeUrl: Uri.tryParse(map["animeUrl"] ?? "") ?? Uri(),
		episodeNumber: map["episodeNumber"] ?? 0,
		thumbnail: Uri.tryParse(map["thumbnail"] ?? "") ?? Uri(),
		url: Uri.tryParse(map["url"] ?? "") ?? Uri(),
		duration: map["duration"] == null ? null : Duration(milliseconds: map["duration"]),
	);

	String toJson() => json.encode(toMap());

	factory NSEpisode.fromJson(String source) => NSEpisode.fromMap(json.decode(source));

	@override
	String toString() =>
		"NSEpisode(animeId: $animeId, animeUrl: $animeUrl, episodeNumber: $episodeNumber, thumbnail: $thumbnail, url: $url, duration: $duration)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is NSEpisode
			&& other.animeId == animeId
			&& other.animeUrl == animeUrl
			&& other.episodeNumber == episodeNumber
			&& other.thumbnail == thumbnail
			&& other.url == url
			&& other.duration == duration;
	}

	@override
	int get hashCode => animeId.hashCode
		^ animeUrl.hashCode
		^ episodeNumber.hashCode
		^ thumbnail.hashCode
		^ url.hashCode
		^ duration.hashCode;
}
