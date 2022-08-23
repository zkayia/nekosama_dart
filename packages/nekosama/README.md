
# nekosama

Unofficial dart api for neko-sama.fr.

## Installation

* Add the package to your dependencies:
```yaml
dependencies:
  nekosama:
    git:
      url: https://github.com/zkayia/nekosama_dart
      path: packages/nekosama
```

## Usage

* Initialise the api:
```dart
final api = NekoSama(
  // (optional) Default: new HttpClient()
  // An HttpClient instance to use for all web requests.
  httpClient: HttpClient(),
);
```

If you omit providing an `HttpClient`, make sure to dispose of the api when you're done:
```dart
api.dispose();
```

* Fetch an anime by url:
```dart
final onePiece = await api.getAnime(
  Uri.parse("https://neko-sama.fr/anime/info/12-one-piece-vostfr")
);
```

* Get the home page:
```dart
final home = await api.getHome();
// List of episodes recently added.
print(home.newEpisodes);
// Six animes from the current season.
print(home.seasonalAnimes);
// The six most popular animes.
print(home.mostPopularAnimes);
```
`seasonalAnimes` and `mostPopularAnimes` are composed of lists of `NSCarouselAnime` which has fewer properties. To get a regular `NSAnime` you can use:
```dart
final fullAnime = await api.getAnime(carouselAnime.url);
```

* Get the episodes of an anime:
```dart
final episodes = await api.getEpisodes(
  anime,
  // (optional) Default: false
  // If anime is an NSAnime, it will simply return anime.episodes,
  // you can avoid the behaviour by setting force to true.
  force: true,
);
```

You can save a web request by trying to guess the episode URLs by using:
```dart
final episodeUrls = await api.guessEpisodeUrls(anime);
```
Be aware that, although often corrent, the guessed URLs are not guaranteed to be.

It might also make a request in the event that `anime` has an episode count of 0 (undefined). This might happend for currently airing anime or if there was an issue extracting the episodes when fetching `anime`.

* Get the video embed url of an episode:
```dart
final videoUrl = await api.getVideoUrl(episode);
```
As of now, this method only works for episodes hosted on `pstream.net`. Futher compatibility is planned.

* Get the search DB:
```dart
final db = await api.getSearchDb(source);
```
This method will return a list of `NSSearchAnime`, similarely to `NSCarouselAnime`, you can use `api.getAnime(searchAnime)` to get a regular `NSAnime`.

You can also get the raw JSON search db as a `List<Map<String, dynamic>>` using:
```dart
final raw = await api.getRawSearchDb(source);
```

In both cases, the optional `source` parameter is used to either fetch the
[VOSTFR DB](https://neko-sama.fr/animes-search-vostfr.json)
(default) or the
[VF DB](https://neko-sama.fr/animes-search-vf.json).