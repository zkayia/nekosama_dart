import 'package:equatable/equatable.dart';
import 'package:nekosama/src/models/anime/ns_carousel_anime.dart';
import 'package:nekosama/src/models/episode/ns_new_episode.dart';
import 'package:nekosama/src/models/ns_website_info.dart';

class NSHome extends Equatable {
  final List<NSNewEpisode> newEpisodes;
  final List<NSCarouselAnime> seasonalAnimes;
  final List<NSCarouselAnime> mostPopularAnimes;
  final List<NSWebsiteInfo> websiteInfos;

  const NSHome({
    required this.newEpisodes,
    required this.seasonalAnimes,
    required this.mostPopularAnimes,
    this.websiteInfos = const [],
  });

  @override
  List<Object?> get props => [newEpisodes, seasonalAnimes, mostPopularAnimes, websiteInfos];

  NSHome copyWith({
    List<NSNewEpisode>? newEpisodes,
    List<NSCarouselAnime>? seasonalAnimes,
    List<NSCarouselAnime>? mostPopularAnimes,
    List<NSWebsiteInfo>? websiteInfos,
  }) =>
      NSHome(
        newEpisodes: newEpisodes ?? this.newEpisodes,
        seasonalAnimes: seasonalAnimes ?? this.seasonalAnimes,
        mostPopularAnimes: mostPopularAnimes ?? this.mostPopularAnimes,
        websiteInfos: websiteInfos ?? this.websiteInfos,
      );
}
