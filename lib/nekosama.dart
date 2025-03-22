/// Unofficial dart api for neko-sama.fr.
library nekosama;

export 'package:nekosama/src/enums/ns_genres.dart' show NSGenres;
export 'package:nekosama/src/enums/ns_sources.dart' show NSSources;
export 'package:nekosama/src/enums/ns_statuses.dart' show NSStatuses;
export 'package:nekosama/src/enums/ns_types.dart' show NSTypes;

export 'package:nekosama/src/models/ns_exception.dart' show NSException, NSNetworkException, NSParseException;
export 'package:nekosama/src/models/anime/ns_anime_base.dart' show NSAnimeBase;
export 'package:nekosama/src/models/anime/ns_anime_extended_base.dart' show NSAnimeExtendedBase;
export 'package:nekosama/src/models/anime/ns_anime.dart' show NSAnime;
export 'package:nekosama/src/models/anime/ns_carousel_anime.dart' show NSCarouselAnime;
export 'package:nekosama/src/models/episode/ns_episode.dart' show NSEpisode;
export 'package:nekosama/src/models/ns_home.dart' show NSHome;
export 'package:nekosama/src/models/episode/ns_new_episode.dart' show NSNewEpisode;
export 'package:nekosama/src/models/anime/ns_search_anime.dart' show NSSearchAnime;
export 'package:nekosama/src/models/anime/ns_anime_titles.dart' show NSAnimeTitles;
export 'package:nekosama/src/models/ns_website_info.dart' show NSWebsiteInfo;

export 'package:nekosama/src/config.dart' show NSConfig;
export 'package:nekosama/src/neko_sama.dart' show NekoSama;
