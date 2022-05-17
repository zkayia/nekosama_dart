
import 'package:nekosama_dart/src/enums/ns_genres.dart';
import 'package:nekosama_dart/src/enums/ns_statuses.dart';
import 'package:nekosama_dart/src/enums/ns_types.dart';
import 'package:nekosama_dart/src/extensions/list_map_type.dart';
import 'package:nekosama_dart/src/helpers/extract_episode_int.dart';
import 'package:nekosama_dart/src/models/ns_anime.dart';
import 'package:nekosama_dart/src/models/ns_titles.dart';


NSAnime parseAnime(Map<String, dynamic> nsMap) => NSAnime(
	id: nsMap["id"] ?? 0,
	title: nsMap["title"] ?? "",
	titles: NSTitles.fromMap({
		"animeId": nsMap["id"] ?? 0,
		"english": nsMap["title_english"],
		"romanji": nsMap["title_romanji"],
		"french": nsMap["title_french"],
		"others": nsMap["others"],
	}),
	genres: (nsMap["genres"] as List?)?.mapType<NSGenres>(
		(e) => NSGenres.fromString(e),
	) ?? [],
	status: NSStatuses.fromString(nsMap["status"] ?? "") ?? NSStatuses.aired,
	type: NSTypes.fromString(nsMap["type"] ?? "") ?? NSTypes.tv,
	year: int.tryParse(nsMap["start_date_year"] ?? "0") ?? 0,
	popularity: nsMap["popularity"] ?? 0.0,
	score: double.tryParse(nsMap["score"] ?? "0.0") ?? 0.0,
	url: "https://neko-sama.fr${nsMap["url"] ?? ""}",
	thumbnail: nsMap["url_image"] ?? "",
	episodeCount: extractEpisodeInt(nsMap["nb_eps"] ?? "0"),
);
