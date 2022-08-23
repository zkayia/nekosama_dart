
# nekosama_hive

Unofficial dart api for neko-sama.fr with Hive powered search.

## Installation

* Add the package to your dependencies
```yaml
dependencies:
  ...
  nekosama_hive:
    git:
      url: https://github.com/zkayia/nekosama_dart
      path: packages/nekosama_hive
```

## Usage

See the
[nekosama package README](/packages/nekosama/README.md)
for basic usage.

* Initialise the search DB:
```dart
await api.hiveSearchDb.init(
  // The path to provide to Hive.init().
  // Required unless Hive was already initialised beforehand.
  "/path/to/db",
);
```
The database will automatically be disposed when calling `api.dispose()`, you can manually dispose of it using: 
```dart
api.hiveSearchDb.dispose();
```


* Populate the search Db:
```dart
await api.hiveSearchDb.populate(source);
```

If you with to get progress information on the populate process, you can use:
```dart
final process = api.hiveSearchDb.populateStream(source);

await for (final event in process) {
  print("${event.progress}/${event.total}");
  if (event.isDone) {
    print("Populate process is done!");
    break;
  }
}
```
In both cases, the optional `source` parameter is used to either fetch the
[VOSTFR DB](https://neko-sama.fr/animes-search-vostfr.json)
(default) or the
[VF DB](https://neko-sama.fr/animes-search-vf.json).

It's currently not possible to have both source in the database at same time.

Populate will clear the current DB, you can also manually clear it using:
```dart
await api.hiveSearchDb.clear();
```

* Search animes:
```dart
final animes = await api.hiveSearchDb.searchAnimes(
  // This compares against all languages.
  title: NSStringQuery.contains("cool anime"),
  // The searched animes must have all the following genres.
  genresHasAll: [
    NSGenres.action,
    NSGenres.adventure,
    NSGenres.drama,
  ],
  // The searched animes must be in any of theses statuses.
  statusesIsAny: [
    NSStatuses.airing,
    NSStatuses.aired,
  ],
  // The searched animes must be any of theses types.
  typesIsAny: [
    NSTypes.movie,
    NSTypes.tv,
  ],
  yearQuery: NSintQuery.between(2010, 2020),
  popularityQuery: NSdoubleQuery.under(10),
  // The score is a double out of 5.
  scoreQuery: NSdoubleQuery.above(3.5),
  episodeCountQuery: NSintQuery.equalsAny([12, 24]),
);
```
In this example, `animes` will be a list of `NSSearchAnime` with a title containing "cool anime", the genres action, adventure and drama, that is airing or has already aired, that is a movie or a tv series, that has started airing between 2010 and 2020, that has a popularity lower than 10, a score greater than 3.5/5 and an episode count of either 12 or 24.

You can also request to only get the ids of theses animes by using:
```dart
final ids = await api.hiveSearchDb.searchIds(
  // Same parameters as above.
);
```

* Using ids:

You can use ids to get an anime:
```dart
final anime = api.hiveSearchDb.getSearchAnime(id);
```

This method will return `null` if the anime with the provided id does not exists in the database.
To verify this, you can use:
```dart
if (api.hiveSearchDb.existsAnime(id)) {
  // Do something.
}
```


