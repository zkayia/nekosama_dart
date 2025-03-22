
# nekosama

Unofficial dart api for neko-sama.fr.

## Installation

* Add the package to your dependencies:
```yaml
dependencies:
  nekosama:
    git: https://github.com/zkayia/nekosama_dart
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

You can change the website host by using:
```dart
NSConfig.host = "neko-sama.fr";
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
// List of website news.
print(home.websiteInfos);
```
`seasonalAnimes` and `mostPopularAnimes` are composed of lists of `NSCarouselAnime` which has fewer properties. To get a regular `NSAnime` you can use:
```dart
final fullAnime = await api.getAnime(carouselAnime.url);
```

* Get the video embed urls for an episode:
```dart
final videoUrls = await api.getVideoUrls(episode.url);
```
This will return a list of links to the video embeds. Might be empty if no video is found.

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