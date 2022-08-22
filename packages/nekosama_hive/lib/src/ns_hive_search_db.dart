
import 'package:hive/hive.dart';
import 'package:nekosama/nekosama.dart';
import 'package:nekosama_hive/src/helpers/add_id_to_box.dart';
import 'package:nekosama_hive/src/models/ns_progress.dart';
import 'package:nekosama_hive/src/querys/ns_double_query.dart';
import 'package:nekosama_hive/src/querys/ns_int_query.dart';
import 'package:nekosama_hive/src/querys/ns_num_query.dart';
import 'package:nekosama_hive/src/querys/ns_string_query.dart';


class NSHiveSearchDb {

  final NekoSama _parent;
  bool _dbActive = false;
  /// Miscellaneous database statistics.
  NSSearchDbStats? stats;
  /// The `DateTime` at which the database was last populated.
  /// 
  /// Returns `null` if the database was never populated.
  DateTime? get lastPopulated => Hive.box("ns_search_info").get("lastPopulated");
  /// Return `true` if the database was initialised.
  bool get dbInitialised => _dbActive;
  /// Return `true` if the database was disposed.
  bool get dbDisposed => !_dbActive;

  NSHiveSearchDb(this._parent);

  /// Initialises the search database.
  /// 
  /// Hive is not initialised unless
  /// [dbDir] is provided. Omit it only if Hive was manually
  /// initialised prior to this method call.
  Future<void> init([String? dbDir]) async {
    try {
      if (dbDir != null) {
        Hive.init(dbDir);
      }
      await Hive.openBox("ns_search_info");
      await Hive.openBox<String>("ns_animes");
      await Hive.openBox<String>("ns_titles");
      await Hive.openBox<List<int>>("ns_genres");
      await Hive.openBox<List<int>>("ns_statuses");
      await Hive.openBox<List<int>>("ns_types");
      await Hive.openBox<List<int>>("ns_years");
      await Hive.openBox<List<int>>("ns_popularity");
      await Hive.openBox<List<int>>("ns_score");
      await Hive.openBox<List<int>>("ns_episodeCount");
      _dbActive = true;
    } on Exception catch (e) {
      throw NekoSamaException("Failed to initialise database, $e");
    }
  }

  /// Closes the search database.
  void dispose() {
    _dbActive = false;
    Hive.close();
  }

  /// Clears the search database.
  Future<void> clear() async {
    await Hive.box("ns_search_info").clear();
    await Hive.box<String>("ns_animes").clear();
    await Hive.box<String>("ns_titles").clear();
    await Hive.box<List<int>>("ns_genres").clear();
    await Hive.box<List<int>>("ns_statuses").clear();
    await Hive.box<List<int>>("ns_types").clear();
    await Hive.box<List<int>>("ns_years").clear();
    await Hive.box<List<int>>("ns_popularity").clear();
    await Hive.box<List<int>>("ns_score").clear();
    await Hive.box<List<int>>("ns_episodeCount").clear();
  }

  /// Populates the search database.
  /// 
  /// [source] is used to choose the database to fetch.
  /// 
  /// Equivalent to [populateStream].
  Future<void> populate([NSSources source=NSSources.vostfr]) async =>
    populateStream(source).firstWhere((progress) => progress.isDone);

  /// Populates the search database.
  /// 
  /// [source] is used to choose the database to fetch.
  /// 
  /// Returns a `Stream` of [NSProgress] that can be
  /// listened to receive progression events.
  /// 
  /// Equivalent to [populate].
  Stream<NSProgress> populateStream([NSSources source=NSSources.vostfr]) async* {
    await clear();
    final searchDb = await _parent.getSearchDb(source);
    final total = searchDb.length;
    final animesBox = Hive.box<String>("ns_animes");
    final titlesBox = Hive.box<String>("ns_titles");
    final statusesBox = Hive.box<List<int>>("ns_statuses");
    final typesBox = Hive.box<List<int>>("ns_types");
    final popularityBox = Hive.box<List<int>>("ns_popularity");
    final scoreBox = Hive.box<List<int>>("ns_score");
    int singleAnimeMaxGenres = 0;
    final Map<int, Set<int>> genres = {};
    final Map<int, Set<int>> years = {};
    final Map<int, Set<int>> epCounts = {};
    yield NSProgress(total: total, progress: 0);
    for (var i = 0; i < total; i++) {
      final anime = searchDb.elementAt(i);
      animesBox.put(anime.id, anime.toJson());
      titlesBox.put(
        anime.id,
        [
          anime.title,
          anime.titles.english ?? "",
          anime.titles.french ?? "",
          anime.titles.romanji ?? "",
          anime.titles.others ?? "",
        ].map((e) => e.toLowerCase().trim()).join(" "),
      );
      if (anime.genres.length > singleAnimeMaxGenres) {
        singleAnimeMaxGenres = anime.genres.length;
      }
      for (final genre in anime.genres) {
        final key = genre.index;
        genres.update(
          key,
          (ids) => <int>{...ids, anime.id},
          ifAbsent: () => <int>{anime.id},
        );
      }
      if (anime.status != NSStatuses.aired) {
        addIdToBox(statusesBox, anime.status.index, anime.id);
      }
      if (anime.type != NSTypes.tv) {
        addIdToBox(typesBox, anime.type.index, anime.id);
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
        final totalStatuses = statusesBox.toMap().map(
          (key, value) => MapEntry(NSStatuses.values.elementAt(key), value.length),
        );
        final totalTypes = typesBox.toMap().map(
          (key, value) => MapEntry(NSTypes.values.elementAt(key), value.length),
        );
        stats = NSSearchDbStats(
          totalAnimes: total,
          totalPerGenre: {
            for (final genre in genres.entries)
              NSGenres.values.elementAt(genre.key): genre.value.length
          },
          totalPerStatus: {
            ...totalStatuses,
            for (final status in NSStatuses.values)
              if (!totalStatuses.containsKey(status))
                status: status == NSStatuses.aired
                  ? total - totalStatuses.values.reduce((value, element) => value + element)
                  : 0,
          },
          totalPerType: {
            ...totalTypes,
            for (final status in NSTypes.values)
              if (!totalTypes.containsKey(status))
                status: status == NSTypes.tv
                  ? total - totalTypes.values.reduce((value, element) => value + element)
                  : 0,
          },
          totalPerYear: years.map((key, value) => MapEntry(key, value.length)),
        );
      }
      yield NSProgress(total: total, progress: i+1);
    }
  }

  /// Get the anime with the provided [id].
  /// 
  /// Returns `null` if [id] doesn't exists.
  Future<NSSearchAnime?> getSearchAnime(int id) async {
    try {
      final anime = Hive.box<String>("ns_animes").get(id);
      return anime == null ? null : NSSearchAnime.fromJson(anime);
    } on Exception catch (e) {
      throw NekoSamaException(
        "Something went wrong while looking for an anime with id $id, $e",
      );
    }
  }

  /// Checks if an anime with [id] exists.
  bool existsAnime(int id) => Hive.box<String>("ns_animes").containsKey(id);

  /// Make a search with the provided filters.
  Future<List<NSSearchAnime>> searchAnimes({
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
        await getSearchAnime(id),
    ]
      .whereType<NSSearchAnime>()
      .toList();
  }
  
  /// Make a search with the provided filters.
  /// 
  /// Returns a list of ids, use [searchAnimes]
  /// to directly get the corresponding [NSSearchAnime].
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
      if (statusesIsAny?.isNotEmpty ?? false)
        [statusesIsAny, NSStatuses.values, NSStatuses.aired, "ns_statuses"],
      if (typesIsAny?.isNotEmpty ?? false)
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
    final Set<int> matches = {};
    final Set<int> toFilter = {};
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
          ...genresBox.get(genre.index) ?? [],
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
      addToMatches(results);
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
            toFilter.addAll(box.get((value as Enum).index) ?? []);
          }
        }
      } else {
        final results = <int>{
          for (final value in set)
            ...box.get((value as Enum).index) ?? [],
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
        ? (box.keys as List<String>).map(double.parse)
        :  box.keys;
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
