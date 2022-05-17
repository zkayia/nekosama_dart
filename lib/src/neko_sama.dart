
import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:hive/hive.dart';
import 'package:nekosama_dart/src/enums/enums_db_adaptors.dart';
import 'package:nekosama_dart/src/enums/ns_genres.dart';
import 'package:nekosama_dart/src/enums/ns_sources.dart';
import 'package:nekosama_dart/src/enums/ns_statuses.dart';
import 'package:nekosama_dart/src/enums/ns_types.dart';
import 'package:nekosama_dart/src/helpers/add_id_to_box.dart';
import 'package:nekosama_dart/src/helpers/extract_episode_int.dart';
import 'package:nekosama_dart/src/helpers/extract_new_episodes.dart';
import 'package:nekosama_dart/src/extensions/uri_get.dart';
import 'package:nekosama_dart/src/helpers/parse_anime.dart';
import 'package:nekosama_dart/src/helpers/parse_carousel.dart';
import 'package:nekosama_dart/src/models/neko_sama_exception.dart';
import 'package:nekosama_dart/src/models/ns_anime.dart';
import 'package:nekosama_dart/src/models/ns_episode.dart';
import 'package:nekosama_dart/src/models/ns_home.dart';
import 'package:nekosama_dart/src/models/ns_progress.dart';
import 'package:nekosama_dart/src/querys/ns_int_query.dart';
import 'package:nekosama_dart/src/querys/ns_double_query.dart';
import 'package:nekosama_dart/src/querys/ns_num_query.dart';
import 'package:nekosama_dart/src/querys/ns_string_query.dart';


/// The main api for the `nekosama_dart` library.
class NekoSama {

	final _boxes = {
		"ns_search_info": null,
		"ns_animes": (Future<void> Function<T>() f) async => f.call<String>(),
		"ns_titles": (Future<void> Function<T>() f) async => f.call<String>(),
		"ns_genres": (Future<void> Function<T>() f) async => f.call<List<int>>(),
		"ns_statuses": (Future<void> Function<T>() f) async => f.call<List<int>>(),
		"ns_types": (Future<void> Function<T>() f) async => f.call<List<int>>(),
		"ns_years": (Future<void> Function<T>() f) async => f.call<List<int>>(),
		"ns_popularity": (Future<void> Function<T>() f) async => f.call<List<int>>(),
		"ns_score": (Future<void> Function<T>() f) async => f.call<List<int>>(),
		"ns_episodeCount": (Future<void> Function<T>() f) async => f.call<List<int>>(),
	};
	/// The source type to use when interacting with `neko-sama.fr`.
	final NSSources source;
	/// An optional `HttpClient` to use to make requests.
	final HttpClient httpClient;
	bool _dbActive = false;
	/// Return `true` if the database was initialised.
	bool get dbInitialised => _dbActive;
	/// Return `true` if the database was disposed.
	bool get dbDisposed => !_dbActive;

	/// The main api for the `nekosama_dart` library.
	NekoSama({
		this.source=NSSources.vostfr,
		HttpClient? httpClient,
	}) : httpClient = httpClient ?? HttpClient();

	/// Initialises the caching database.
	/// 
	/// Hive is not initialised unless
	/// [cacheDir] is provided. Omit it only if Hive was manually
	/// initialised prior to this method call.
	Future<void> initDb([String? cacheDir]) async {
		try {
			if (cacheDir != null) {
				Hive.init(cacheDir);
			}
			for (final box in _boxes.entries) {
				if (box.value == null) {
					await Hive.openBox(box.key);
					continue;
				}
				await box.value?.call(<B>() async => Hive.openBox<B>(box.key));
			}
			_dbActive = true;
		} catch (e) {
			throw NekoSamaException("Failed to initialise database, $e");
		}
	}

	/// Closes the caching database.
	void disposeDb() {
		_dbActive = false;
		Hive.close();
	}

	/// Clears the caching database.
	Future<void> clearDb() async {
		for (final box in _boxes.entries) {
			if (box.value == null) {
				await Hive.box(box.key).clear();
				continue;
			}
			await box.value?.call(<B>() async => Hive.box<B>(box.key).clear());
		}
	}

	/// Populates the caching database.
	/// 
	/// Equivalent to [populateDbStream].
	Future<void> populateDb() async =>
		populateDbStream().firstWhere((progress) => progress.isDone);

	/// Populates the caching database.
	/// 
	/// Returns a `Stream` of [NSProgress] that can be
	/// listened to receive progression events.
	/// 
	/// Equivalent to [populateDb].
	Stream<NSProgress> populateDbStream() async* {
		await clearDb();
		final rawSearchDB = await Uri.https(
			"neko-sama.fr",
			"/animes-search-${source.name}.json",
		).get(httpClient: httpClient);
		final searchDB = jsonDecode(rawSearchDB.body) as List;
		final total = searchDB.length;
		final animesBox = Hive.box<String>("ns_animes");
		final titlesBox = Hive.box<String>("ns_titles");
		final statusesBox = Hive.box<List<int>>("ns_statuses");
		final typesBox = Hive.box<List<int>>("ns_types");
		final popularityBox = Hive.box<List<int>>("ns_popularity");
		final scoreBox = Hive.box<List<int>>("ns_score");
		int singleAnimeMaxGenres = 0;
		Map<int, Set<int>> genres = {};
		Map<int, Set<int>> years = {};
		Map<int, Set<int>> epCounts = {};
		yield NSProgress(total: total, progress: 0);
		for (var i = 0; i < total; i++) {
			final anime = parseAnime(searchDB.elementAt(i));
			animesBox.put(anime.id, anime.toJson());
			titlesBox.put(
				anime.id,
				[
					anime.title,
					anime.titles.english,
					anime.titles.french,
					anime.titles.romanji,
					anime.titles.others,
				].join(" "),
			);
			if (anime.genres.length > singleAnimeMaxGenres) {
				singleAnimeMaxGenres = anime.genres.length;
			}
			for (final genre in anime.genres) {
				final key = enumToDb(genre);
				genres.update(
					key,
					(ids) => <int>{...ids, anime.id},
					ifAbsent: () => <int>{anime.id},
				);
			}
			if (anime.status != NSStatuses.aired) {
				addIdToBox(statusesBox, enumToDb(anime.status), anime.id);
			}
			if (anime.type != NSTypes.tv) {
				addIdToBox(typesBox, enumToDb(anime.type), anime.id);
			}
			years.update(
				anime.year,
				(ids) => <int>{...ids, anime.id},
				ifAbsent: () => <int>{anime.id},
			);
			addIdToBox(popularityBox, anime.popularity.toString(), anime.id);
			addIdToBox(scoreBox, anime.score.toString(), anime.id);
			epCounts.update(
				anime.episodeCount,
				(ids) => <int>{...ids, anime.id},
				ifAbsent: () => <int>{anime.id},
			);
			if (total == i+1) {
				for (final element in [
					[genres, "ns_genres"],
					[years, "ns_years"],
					[epCounts, "ns_episodeCount"],
				]) {
					Hive.box<List<int>>(element.last as String).putAll({
						for (final entry in (element.first as Map).entries)
							entry.key: [...entry.value]
					});
				}
				final infoBox = Hive.box("ns_search_info");
				infoBox.put("singleAnimeMaxGenres", singleAnimeMaxGenres);
				infoBox.put("lastPopulated", DateTime.now());
			}
			yield NSProgress(total: total, progress: i+1);
		}
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

	/// Get the anime with the provided [id].
	/// 
	/// Uses the caching database, returns null if it
	/// doesn't contain [id].
	Future<NSAnime?> getAnime(int id) async {
		try {
			final anime = Hive.box<String>("ns_animes").get(id);
			return anime == null ? null : NSAnime.fromJson(anime);
		} catch (e) {
			throw NekoSamaException(
				"Something went wrong while looking for an anime with id $id, $e",
			);
		}
	}

	/// Checks if an anime with [id] exists in the caching database.
	bool existsAnime(int id) => Hive.box<String>("ns_animes").containsKey(id);

	/// Tries to guess the episode urls of [anime].
	/// 
	/// Provided as a request-free alternative to [getEpisodes].
	/// 
	/// Guessed urls are not guaranteed to be correct.
	/// 
	/// If [anime] has 0 episodes, calls [getEpisodes], then
	/// returns `null` if no episodes were found.
	Future<List<String>?> guessEpisodeUrls(NSAnime anime) async {
		String zeroPadInt(int number) => "${number < 10 ? "0": ""}$number";
		if (anime.episodeCount == 0) {
			final eps = await getEpisodes(anime);
			return eps == null
				? null
				: [...eps.map((e) => e.url)];
		}
		return [
			for (var i = 1; i < anime.episodeCount+1; i++)
				anime.url
					.replaceFirst("/info/", "/episode/")
					.replaceFirst(
						RegExp("-${source.apiName}\$"),
						"-${zeroPadInt(i)}-${source.apiName}",
					),
		];
	}

	/// Gets the [NSEpisode] list of [anime].
	/// 
	/// Returns `null` if no episodes were found.
	Future<List<NSEpisode>?> getEpisodes(NSAnime anime) async {
		try {
			final animePageResponse = await Uri.parse(anime.url).get(
				httpClient: httpClient,
			);
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
						url: "https://neko-sama.fr${episode["url"]}",
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
					(await Uri.parse(episode.url).get(httpClient: httpClient)).body,
				)?.group(1);
		} catch (e) {
			throw NekoSamaException("Failed to get the video link, $e");
		}
	}

	/// Make a search with the provided filters.
	Future<List<NSAnime>> searchAnimes({
		NSStringQuery? title,
		Iterable<NSGenres>? genresHasAll,
		Iterable<NSStatuses>? statusesIsAny,
		Iterable<NSTypes>? typesIsAny,
		NSintQuery? yearQuery,
		NSdoubleQuery? popularityQuery,
		NSdoubleQuery? scoreQuery,
		NSintQuery? episodeCountQuery,
	}) async {
		final results = await searchIds(
			title: title,
			genresHasAll: genresHasAll,
			statusesIsAny: statusesIsAny,
			typesIsAny: typesIsAny,
			yearQuery: yearQuery,
			popularityQuery: popularityQuery,
			scoreQuery: scoreQuery,
			episodeCountQuery: episodeCountQuery,
		);
		return [
			for (final id in results)
				await getAnime(id),
		]
			.whereType<NSAnime>()
			.toList();
	}
	
	/// Make a search with the provided filters.
	/// 
	/// Returns a list of ids, use [searchAnimes]
	/// to directly get the corresponding [NSAnime].
	Future<List<int>> searchIds({
		NSStringQuery? title,
		Iterable<NSGenres>? genresHasAll,
		Iterable<NSStatuses>? statusesIsAny,
		Iterable<NSTypes>? typesIsAny,
		NSintQuery? yearQuery,
		NSdoubleQuery? popularityQuery,
		NSdoubleQuery? scoreQuery,
		NSintQuery? episodeCountQuery,
	}) async {
		final infoBox = Hive.box("ns_search_info");
		final genres = {...genresHasAll ?? {}};
		final isAnyEnums = [
			if (statusesIsAny != null)
				[statusesIsAny, NSStatuses.values, NSStatuses.aired, "ns_statuses"],
			if (typesIsAny != null)
				[typesIsAny, NSTypes.values, NSTypes.tv, "ns_types"],
		];
		final numQuerys = [
			if (yearQuery != null)
				[yearQuery, "ns_years"],
			if (popularityQuery != null)
				[popularityQuery, "ns_popularity"],
			if (scoreQuery != null)
				[scoreQuery, "ns_score"],
			if (episodeCountQuery != null)
				[episodeCountQuery, "ns_episodeCount"],
		];
		Set<int> matches = {};
		Set<int> toFilter = {};
		void addToMatches(Set<int> values) {
			if (matches.isEmpty) {
				return matches.addAll(values);
			}
			matches.retainAll(values);
		}
		if (genres.length > (infoBox.get("singleAnimeMaxGenres") ?? NSGenres.values.length)) {
			return [];
		}
		if (title != null) {
			final titlesBox = Hive.box<String>("ns_titles");
			final titles = titlesBox.values;
			final results = <int>{
				for (var i = 0; i < titles.length; i++)
					if (title.operation.call(titles.elementAt(i)))
						titlesBox.keyAt(i),
			};
			if (results.isEmpty) {
				return [];
			}
			addToMatches(results);
		}
		if (genres.isNotEmpty) {
			final genresBox = Hive.box<List<int>>("ns_genres");
			final Set<int> results = {};
			for (final genre in genres) {
				final Set<int> genreResults = {
					...genresBox.get(enumToDb(genre)) ?? [],
				};
				if (results.isEmpty) {
					results.addAll(genreResults);
				} else {
					results.retainAll(genreResults);
				}
				if (results.isEmpty) {
					return [];
				}
			}
		}
		for (final isAny in isAnyEnums) {
			final set = {...(isAny.first as Iterable?) ?? {}};
			final enumValues = isAny.elementAt(1) as List;
			if (set.isEmpty && set.length == enumValues.length) {
				continue;
			}
			final box = Hive.box<List<int>>(isAny.last as String);
			if (set.contains(isAny.elementAt(2))) {
				for (final value in enumValues) {
					if (!set.contains(value)) {
						toFilter.addAll(box.get(enumToDb(value as Enum)) ?? []);
					}
				}
			} else {
				final results = <int>{
					for (final value in set)
						...box.get(enumToDb(value as Enum)) ?? [],
				};
				if (results.isEmpty) {
					return [];
				}
				addToMatches(results);
			}
		}
		for (var i = 0; i < numQuerys.length; i++) {
			final query = numQuerys.elementAt(i).first as NSnumQuery?;
			if (query == null) {
				continue;
			}
			final box = Hive.box<List<int>>(numQuerys.elementAt(i).last as String);
			final keys = [1, 2].contains(i)
				? box.keys.map((e) => double.parse(e))
				:	box.keys;
			final results = <int>{
				for (final key in keys)
					if (query.operation.call(key))
						...box.get(key) ?? [],
			};
			if (results.isEmpty) {
				return [];
			}
			addToMatches(results);
		}
		if (matches.isEmpty) {
			return [
				if (toFilter.isNotEmpty)
					...{...Hive.box<String>("ns_animes").keys}.difference(toFilter),
			];
		}
		if (toFilter.isEmpty) {
			return [...matches];
		}
		return [...matches.difference(toFilter)];
	}
}
