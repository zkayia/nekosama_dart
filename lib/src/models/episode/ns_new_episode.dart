import 'package:nekosama/src/enums/ns_new_episode_icon.dart';
import 'package:nekosama/src/models/episode/ns_episode.dart';

class NSNewEpisode extends NSEpisode {
  final Uri animeUrl;
  final DateTime addedAt;
  final String title;
  final Uri thumbnail;
  final Uri animeThumbnail;
  final List<NSNewEpisodeIcon> icons;

  const NSNewEpisode({
    required super.episodeNumber,
    required super.url,
    required this.animeUrl,
    required this.addedAt,
    required this.title,
    required this.thumbnail,
    required this.animeThumbnail,
    this.icons = const [],
  });

  @override
  List<Object?> get props => [...super.props, animeUrl, addedAt, title, thumbnail, animeThumbnail, icons];

  @override
  NSNewEpisode copyWith({
    int? episodeNumber,
    Uri? url,
    Uri? animeUrl,
    DateTime? addedAt,
    Uri? thumbnail,
    String? episodeTitle,
    Uri? animeThumbnail,
    List<NSNewEpisodeIcon>? icons,
  }) =>
      NSNewEpisode(
        episodeNumber: episodeNumber ?? this.episodeNumber,
        url: url ?? this.url,
        animeUrl: animeUrl ?? this.animeUrl,
        addedAt: addedAt ?? this.addedAt,
        title: episodeTitle ?? this.title,
        thumbnail: thumbnail ?? this.thumbnail,
        animeThumbnail: animeThumbnail ?? this.animeThumbnail,
        icons: icons ?? this.icons,
      );
}
