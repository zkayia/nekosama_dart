import 'dart:convert';



class NSEpisode {

	final int animeId;
	final int episodeNumber;
	final Uri thumbnail;
	final Uri url;
	
	NSEpisode({
		required this.animeId,
		required this.episodeNumber,
		required this.thumbnail,
		required this.url,
	});

	NSEpisode copyWith({
		int? animeId,
		int? episodeNumber,
		Uri? thumbnail,
		Uri? url,
	}) => NSEpisode(
		animeId: animeId ?? this.animeId,
		episodeNumber: episodeNumber ?? this.episodeNumber,
		thumbnail: thumbnail ?? this.thumbnail,
		url: url ?? this.url,
	);

	Map<String, dynamic> toMap() => {
		"animeId": animeId,
		"episodeNumber": episodeNumber,
		"thumbnail": thumbnail.toString(),
		"url": url.toString(),
	};

	factory NSEpisode.fromMap(Map<String, dynamic> map) => NSEpisode(
		animeId: int.parse(map["animeId"] ?? "0"),
		episodeNumber: int.parse(map["episodeNumber"] ?? "0"),
		thumbnail: Uri.tryParse(map["thumbnail"] ?? "") ?? Uri(),
		url: Uri.tryParse(map["url"] ?? "") ?? Uri(),
	);

	String toJson() => json.encode(toMap());

	factory NSEpisode.fromJson(String source) => NSEpisode.fromMap(json.decode(source));

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
