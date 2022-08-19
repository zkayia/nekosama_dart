
import 'package:nekosama/src/models/neko_sama_exception.dart';


int extractAnimeIdFromLink(dynamic link) {
	final animeLink = link is String
		? Uri.parse(link)
		: link is Uri
			? link
			: throw ArgumentError.value(link, "link", "must be String or Uri");
	final err = NekoSamaException("unable to extract anime id from link $animeLink");
	for (var i = 2; i < animeLink.pathSegments.length; i++) {
		if (
			animeLink.pathSegments[i-2] == "anime"
			&& animeLink.pathSegments[i-1] == "info"
		) {
			return int.tryParse(
				RegExp(r"^(\d+)-").firstMatch(
					animeLink.pathSegments[i],
				)?.group(1) ?? "",
			) ?? (throw err);
		}
	}
	throw err;
}
