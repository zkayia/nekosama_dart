
import 'package:nekosama_dart/src/models/ns_anime_base.dart';


class NSCarouselAnime extends NSAnimeBase {

	final int year;
	
	NSCarouselAnime({
		required super.id,
		required super.title,
		required super.url,
		required super.thumbnail,
		required super.episodeCount,
		required this.year,
	});

	NSCarouselAnime copyWith({
		int? id,
		String? title,
		String? url,
		String? thumbnail,
		int? episodeCount,
		int? year,
	}) => NSCarouselAnime(
		id: id ?? this.id,
		title: title ?? this.title,
		url: url ?? this.url,
		thumbnail: thumbnail ?? this.thumbnail,
		episodeCount: episodeCount ?? this.episodeCount,
		year: year ?? this.year,
	);

	@override
	String toString() =>
		"NSCarouselAnime(id: $id, title: $title, url: $url, thumbnail: $thumbnail, episodeCount: $episodeCount, year: $year)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is NSCarouselAnime
			&& other.id == id
			&& other.title == title
			&& other.url == url
			&& other.thumbnail == thumbnail
			&& other.episodeCount == episodeCount
			&& other.year == year;
	}

	@override
	int get hashCode => id.hashCode
		^ title.hashCode
		^ url.hashCode
		^ thumbnail.hashCode
		^ episodeCount.hashCode
		^ year.hashCode;
}
