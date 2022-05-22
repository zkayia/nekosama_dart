
import 'package:nekosama_dart/src/models/ns_episode.dart';

class NSDatedEpisode extends NSEpisode {

	final DateTime addedAt;
	
	NSDatedEpisode({
		required this.addedAt,
		required super.animeId,
		required super.episodeNumber,
		required super.thumbnail,
		required super.url,
	});

	@override
	NSDatedEpisode copyWith({
		DateTime? addedAt,
		int? animeId,
		int? episodeNumber,
		Uri? thumbnail,
		Uri? url,
	}) => NSDatedEpisode(
		addedAt: addedAt ?? this.addedAt,
		animeId: animeId ?? this.animeId,
		episodeNumber: episodeNumber ?? this.episodeNumber,
		thumbnail: thumbnail ?? this.thumbnail,
		url: url ?? this.url,
	);

	@override
	String toString() => "NSDatedEpisode(addedAt: $addedAt)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is NSDatedEpisode && other.addedAt == addedAt;
	}

	@override
	int get hashCode => addedAt.hashCode;
}
