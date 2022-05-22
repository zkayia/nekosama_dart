
import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:nekosama_dart/src/enums/ns_sources.dart';
import 'package:nekosama_dart/src/helpers/extract_episode_int.dart';
import 'package:nekosama_dart/src/helpers/extract_new_episodes.dart';
import 'package:nekosama_dart/src/extensions/uri_get.dart';
import 'package:nekosama_dart/src/helpers/parse_carousel.dart';
import 'package:nekosama_dart/src/models/neko_sama_exception.dart';
import 'package:nekosama_dart/src/models/ns_search_anime.dart';
import 'package:nekosama_dart/src/models/ns_episode.dart';
import 'package:nekosama_dart/src/models/ns_home.dart';
import 'package:nekosama_dart/src/search_db.dart';


/// The main api for the `nekosama_dart` library.
class NekoSama {
	/// The source type to use when interacting with `neko-sama.fr`.
	final NSSources source;
	/// An optional `HttpClient` to use to make requests.
	final HttpClient httpClient;
	/// The search database handler.
	late NSSearchDb searchDb;

	/// The main api for the `nekosama_dart` library.
	NekoSama({
		this.source=NSSources.vostfr,
		HttpClient? httpClient,
	}) : httpClient = httpClient ?? HttpClient() {
		searchDb = NSSearchDb(this);
	}

	/// Gets the home page.
	Future<NSHome> getHome() async {
		final homePageResponse = await Uri.https("neko-sama.fr", "").get(
			httpClient: httpClient,
		);
		final carousels = parse(homePageResponse.body).getElementsByClassName("row anime-listing");
		return NSHome(
			newEpisodes: extractNewEpisodes(homePageResponse),
			seasonalAnimes: parseCarousel(carousels.first),
			mostPopularAnimes: parseCarousel(carousels.last),
		);
	}

	/// Tries to guess the episode urls of [anime].
	/// 
	/// Provided as a request-free alternative to [getEpisodes].
	/// 
	/// Guessed urls are not guaranteed to be correct.
	/// 
	/// If [anime] has 0 episodes, calls [getEpisodes], then
	/// returns `null` if no episodes were found.
	Future<List<Uri>?> guessEpisodeUrls(NSSearchAnime anime) async {
		String zeroPadInt(int number) => "${number < 10 ? "0": ""}$number";
		if (anime.episodeCount == 0) {
			final eps = await getEpisodes(anime);
			return eps == null
				? null
				: [...eps.map((e) => e.url)];
		}
		return [
			for (var i = 1; i < anime.episodeCount+1; i++)
				Uri.parse(
					anime.url
						.toString()
						.replaceFirst("/info/", "/episode/")
						.replaceFirst(
							RegExp("-${source.apiName}\$"),
							"-${zeroPadInt(i)}-${source.apiName}",
						),
				),
		];
	}

	/// Gets the [NSEpisode] list of [anime].
	/// 
	/// Returns `null` if no episodes were found.
	Future<List<NSEpisode>?> getEpisodes(NSSearchAnime anime) async {
		try {
			final animePageResponse = await anime.url.get(httpClient: httpClient);
			final rawEps = RegExp(r"(?<=var\sepisodes\s=\s)\[.+\](?=;)")
				.firstMatch(animePageResponse.body)?.group(0);
			if (rawEps == null) {
				return null;
			}
			return [
				for (final Map<String, dynamic> episode in jsonDecode(rawEps))
					NSEpisode(
						animeId: anime.id,
						episodeNumber: extractEpisodeInt(episode["episode"]),
						thumbnail: episode["url_image"],
						url: Uri.parse("https://neko-sama.fr${episode["url"] ?? ""}"),
					),
			];
		} catch (e) {
			throw NekoSamaException("Failed to parse episode data");
		}
	}

	/// Gets the url of the video player embed of [episode].
	/// 
	/// Currently only supports episode videos hosted on `pstream.net`.
	Future<String?> getVideoUrl(NSEpisode episode) async {
		try {
			return RegExp(r"=\s'(https://www.pstream.net/e/.+)'")
				.firstMatch(
					(await episode.url.get(httpClient: httpClient)).body,
				)?.group(1);
		} catch (e) {
			throw NekoSamaException("Failed to get the video link, $e");
		}
	}
}
