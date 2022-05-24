
import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:nekosama_dart/src/enums/ns_genres.dart';
import 'package:nekosama_dart/src/enums/ns_sources.dart';
import 'package:nekosama_dart/src/enums/ns_statuses.dart';
import 'package:nekosama_dart/src/enums/ns_types.dart';
import 'package:nekosama_dart/src/extensions/list_map_type.dart';
import 'package:nekosama_dart/src/helpers/extract_anime_id.dart';
import 'package:nekosama_dart/src/helpers/extract_episode_int.dart';
import 'package:nekosama_dart/src/helpers/extract_date.dart';
import 'package:nekosama_dart/src/helpers/extract_new_episodes.dart';
import 'package:nekosama_dart/src/extensions/uri_get.dart';
import 'package:nekosama_dart/src/helpers/parse_carousel.dart';
import 'package:nekosama_dart/src/models/neko_sama_exception.dart';
import 'package:nekosama_dart/src/models/ns_anime.dart';
import 'package:nekosama_dart/src/models/ns_anime_base.dart';
import 'package:nekosama_dart/src/models/ns_carousel_anime.dart';
import 'package:nekosama_dart/src/models/ns_search_anime.dart';
import 'package:nekosama_dart/src/models/ns_episode.dart';
import 'package:nekosama_dart/src/models/ns_home.dart';
import 'package:nekosama_dart/src/models/ns_titles.dart';
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

	/// Gets an [NSAnime] from it's url.
	Future<NSAnime> getAnime(Uri url) async {
		try {
			final animePageBody = (await url.get(httpClient: httpClient)).body;
			final document = parse(animePageBody);
			final	id = extractAnimeIdFromLink(url);
			final title = document.getElementsByTagName("h1").first;
			final infos = document.getElementById("anime-info-list")?.children;
			final synopsisRaw = document.querySelector(".synopsis > p")?.text.trim();
			final synopsis = synopsisRaw == null || synopsisRaw.toLowerCase().contains("aucun synopsis pour le moment")
				? null
				: synopsisRaw;
			final rawEps = RegExp(r"(?<=var\sepisodes\s=\s)\[.+\](?=;)")
				.firstMatch(animePageBody)?.group(0);
			final episodes = [
				if (rawEps != null)
					for (final Map<String, dynamic> episode in jsonDecode(rawEps))
						NSEpisode(
							animeId: id,
							episodeNumber: extractEpisodeInt(episode["episode"]),
							thumbnail: Uri.tryParse(episode["url_image"] ?? "") ?? Uri(),
							url: Uri.parse("https://neko-sama.fr${episode["url"] ?? ""}"),
						),
			];
			final dates = infos?.last.text.split("-");
			return NSAnime(
				id: id,
				title: title.text,
				url: url,
				thumbnail: Uri.tryParse(document.querySelector(".cover > img")?.attributes["src"] ?? "") ?? Uri(),
				episodeCount: extractEpisodeInt(infos?.elementAt(3).text ?? "?"),
				titles: NSTitles(
					animeId: id,
					others: title.firstChild?.text,
				),
				genres: document.getElementsByClassName("tag list").first.children.mapType<NSGenres>(
					(e) => NSGenres.fromString(e.attributes["href"] ?? ""),
				),
				source: source,
				status: NSStatuses.fromString(
					RegExp(r"^\s\w+(.+)").firstMatch(infos?.elementAt(2).text ?? "")?.group(1) ?? "",
				) ?? NSStatuses.aired,
				type: NSTypes.fromString(
					RegExp(r"^\s\w+(.+)").firstMatch(infos?.elementAt(1).text ?? "")?.group(1) ?? "",
				) ?? NSTypes.tv,
				score: double.tryParse(
					RegExp(r"(\d+\.?\d*)\/5").firstMatch(infos?.first.text ?? "")?.group(1) ?? "",
				) ?? 0.0,
				synopsis: synopsis,
				episodes: episodes,
				startDate: extractDate(dates?.first ?? ""),
				endDate: extractDate(dates?.last ?? ""),
			);
		} catch (e) {
			throw NekoSamaException("Failed to get anime at url '$url', $e");
		}
	}

	/// Gets an [NSAnime] from a [NSSearchAnime] or [NSCarouselAnime].
	Future<NSAnime> getFullAnime(NSAnimeBase anime) async => getAnime(anime.url);

	/// Tries to guess the episode urls of [anime].
	/// 
	/// Provided as a request-free alternative to [getEpisodes].
	/// 
	/// Guessed urls are not guaranteed to be correct.
	/// 
	/// If [anime] has 0 episodes, calls [getEpisodes], then
	/// returns `null` if no episodes were found.
	Future<List<Uri>?> guessEpisodeUrls(NSAnimeBase anime) async {
		if (anime is NSAnime) {
			return [...anime.episodes.map((e) => e.url)];
		}
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
	Future<List<NSEpisode>?> getEpisodes(NSAnimeBase anime) async {
		try {
			if (anime is NSAnime) {
				return anime.episodes;
			}
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
	Future<Uri?> getVideoUrl(NSEpisode episode) async {
		try {
			return Uri.tryParse(
				RegExp(r"=\s'(https://www.pstream.net/e/.+)'")
					.firstMatch((await episode.url.get(httpClient: httpClient)).body,
				)?.group(1) ?? "",
			);
		} catch (e) {
			throw NekoSamaException("Failed to get the video link, $e");
		}
	}
}
