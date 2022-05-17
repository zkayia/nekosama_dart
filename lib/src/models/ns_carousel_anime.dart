

class NSCarouselAnime {

	final int id;
	final String title;
	final int year;
	final String url;
	final String thumbnail;
	final int episodeCount;
	
	NSCarouselAnime({
		required this.id,
		required this.title,
		required this.year,
		required this.url,
		required this.thumbnail,
		required this.episodeCount,
	});

	NSCarouselAnime copyWith({
		int? id,
		String? title,
		int? year,
		String? url,
		String? thumbnail,
		int? episodeCount,
	}) => NSCarouselAnime(
		id: id ?? this.id,
		title: title ?? this.title,
		year: year ?? this.year,
		url: url ?? this.url,
		thumbnail: thumbnail ?? this.thumbnail,
		episodeCount: episodeCount ?? this.episodeCount,
	);

	@override
	String toString() =>
		"NSCarouselAnime(id: $id, title: $title, year: $year, url: $url, thumbnail: $thumbnail, episodeCount: $episodeCount)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is NSCarouselAnime
			&& other.id == id
			&& other.title == title
			&& other.year == year
			&& other.url == url
			&& other.thumbnail == thumbnail
			&& other.episodeCount == episodeCount;
	}

	@override
	int get hashCode => id.hashCode
		^ title.hashCode
		^ year.hashCode
		^ url.hashCode
		^ thumbnail.hashCode
		^ episodeCount.hashCode;
}
