
import 'package:html/dom.dart';
import 'package:nekosama/src/helpers/extract_anime_source.dart';
import 'package:nekosama/src/models/neko_sama_exception.dart';
import 'package:nekosama/src/helpers/extract_anime_id.dart';
import 'package:nekosama/src/models/ns_carousel_anime.dart';


List<NSCarouselAnime> parseCarousel(Element carousel) => [
  for (final element in carousel.children)
    parseCarouselElement(element),
];

NSCarouselAnime parseCarouselElement(Element carouselElement) {
  try {
    final matches = RegExp(r"^(\d+)\s-\s(\d+)\sEps$").firstMatch(
      carouselElement.getElementsByClassName("episode").first.text,
    );
    final url = Uri.parse(
      "https://neko-sama.fr${carouselElement.getElementsByTagName("a").first.attributes["href"] ?? ""}",
    );
    return NSCarouselAnime(
      id: extractAnimeId(url),
      title: carouselElement.getElementsByClassName("title").first.text,
      year: int.parse(matches?.group(1) ?? ""),
      url: url,
      source: extractAnimeSource(url.toString()),
      thumbnail: Uri.parse(carouselElement.getElementsByClassName("lazy").first.attributes["data-src"] ?? ""),
      episodeCount: int.parse(matches?.group(2) ?? ""),
    );
  } on Exception catch (e) {
    throw NekoSamaException("Unable to extract anime from carousel element", e);
  }
}
