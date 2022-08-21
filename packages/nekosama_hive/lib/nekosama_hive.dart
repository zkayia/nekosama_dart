
/// Unofficial dart api for neko-sama.fr.
library nekosama_hive;


export 'package:nekosama/nekosama.dart' show 
	NSGenres,
	NSSources,
	NSStatuses,
	NSTypes,
	NSAnimeBase,
	NSAnimeExtendedBase,
	NSAnime,
	NSCarouselAnime,
	NSEpisode,
	NSHome,
	NSNewEpisode,
	NSTitles;

export 'package:nekosama_hive/src/querys/ns_double_query.dart' show
	NSdoubleQuery;
export 'package:nekosama_hive/src/querys/ns_int_query.dart' show
	NSintQuery;
export 'package:nekosama_hive/src/querys/ns_string_query.dart' show
	NSStringQuery;

export 'package:nekosama_hive/src/neko_sama.dart' show
	NekoSama;
export 'package:nekosama_hive/src/ns_hive_search_db.dart' show
	NSHiveSearchDb;