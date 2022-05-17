

/// All genres available on `neko-sama.fr`.
enum NSGenres {
	
	action(
		"action",
		"action",
		"action",
	),
	adventure(
		"adventure",
		"adventure",
		"aventure",
	),
	comedy(
		"c0m1dy",
		"comedy",
		"comédie",
	),
	drama(
		"drama",
		"drama",
		"drama",
	),
	ecchi(
		"ecchi",
		"ecchi",
		"ecchi",
	),
	fantasy(
		"fantasy",
		"fantasy",
		"fantastique",
	),
	hentai(
		"hentai",
		"hentai",
		"hentai",
	),
	horror(
		"horror",
		"horror",
		"horreur",
	),
	magicalGirl(
		"mahou shoujo",
		"magical girl",
		"magical girl",
	),
	mecha(
		"mecha",
		"mecha",
		"mecha",
	),
	music(
		"music",
		"music",
		"musique",
	),
	mystery(
		"mystery",
		"mystery",
		"mystère",
	),
	psychological(
		"psychological",
		"psychological",
		"psychologique",
	),
	romance(
		"romance",
		"romance",
		"romance",
	),
	sciFi(
		"sci-fi",
		"sci-fi",
		"sci-fi",
	),
	sliceOfLife(
		"slice of life",
		"slice of life",
		"tranche de vie",
	),
	sports(
		"sports",
		"sports",
		"sports",
	),
	supernatural(
		"supernatural",
		"supernatural",
		"supernaturel",
	),
	thriller(
		"thriller",
		"thriller",
		"suspense",
	);

	/// The name used internally by the website.
	final String apiName;
	/// The english name.
	final String englishName;
	/// The french name.
	final String frenchName;

	const NSGenres(this.apiName, this.englishName, this.frenchName);

	/// The url of this genre.
	Uri get url => Uri.parse("https://neko-sama.fr/anime/#{\"genres\":[\"$apiName\"]}");

	/// Contruct a [NSGenres] from a `String`.
	/// 
	/// Returns `null` if [genre] is not a valid value.
	static NSGenres? fromString(String genre) {
		final name = genre.trim().toLowerCase();
		for (final genre in NSGenres.values) {
			if ([genre.apiName, genre.englishName, genre.frenchName].contains(name)) {
				return genre;
			}
		}
		return null;
	}
}
