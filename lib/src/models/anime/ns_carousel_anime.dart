import 'package:nekosama/src/enums/ns_sources.dart';
import 'package:nekosama/src/models/anime/ns_anime_base.dart';

class NSCarouselAnime extends NSAnimeBase {
  final int year;

  const NSCarouselAnime({
    required super.id,
    required super.title,
    required super.url,
    required super.source,
    required super.thumbnail,
    required super.episodeCount,
    required this.year,
  });

  @override
  List<Object?> get props => [...super.props, year];

  NSCarouselAnime copyWith({
    int? id,
    String? title,
    Uri? url,
    NSSources? source,
    Uri? thumbnail,
    int? episodeCount,
    int? year,
  }) =>
      NSCarouselAnime(
        id: id ?? this.id,
        title: title ?? this.title,
        url: url ?? this.url,
        source: source ?? this.source,
        thumbnail: thumbnail ?? this.thumbnail,
        episodeCount: episodeCount ?? this.episodeCount,
        year: year ?? this.year,
      );
}
