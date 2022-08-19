

abstract class NSAnimeBase {

	final int id;
	final String title;
	final Uri url;
	final Uri thumbnail;
	final int episodeCount;

	NSAnimeBase({
		required this.id,
		required this.title,
		required this.url,
		required this.thumbnail,
		required this.episodeCount,
	});
}
