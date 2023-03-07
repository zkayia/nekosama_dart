
import 'package:collection/collection.dart';
import 'package:nekosama/src/models/ns_carousel_anime.dart';
import 'package:nekosama/src/models/ns_new_episode.dart';
import 'package:nekosama/src/models/ns_website_info.dart';

class NSHome {

  final List<NSNewEpisode> newEpisodes;
  final List<NSCarouselAnime> seasonalAnimes;
  final List<NSCarouselAnime> mostPopularAnimes;
  final List<NSWebsiteInfo> websiteInfos;
  
  NSHome({
    required this.newEpisodes,
    required this.seasonalAnimes,
    required this.mostPopularAnimes,
    this.websiteInfos=const [],
  });

  NSHome copyWith({
    List<NSNewEpisode>? newEpisodes,
    List<NSCarouselAnime>? seasonalAnimes,
    List<NSCarouselAnime>? mostPopularAnimes,
    List<NSWebsiteInfo>? websiteInfos,
  }) => NSHome(
    newEpisodes: newEpisodes ?? this.newEpisodes,
    seasonalAnimes: seasonalAnimes ?? this.seasonalAnimes,
    mostPopularAnimes: mostPopularAnimes ?? this.mostPopularAnimes,
    websiteInfos: websiteInfos ?? this.websiteInfos,
  );

  @override
  String toString() =>
    "NSHome(newEpisodes: $newEpisodes, seasonalAnimes: $seasonalAnimes, mostPopularAnimes: $mostPopularAnimes, websiteInfos: $websiteInfos)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    final listEquals = const DeepCollectionEquality().equals;
    return other is NSHome
      && listEquals(other.newEpisodes, newEpisodes)
      && listEquals(other.seasonalAnimes, seasonalAnimes)
      && listEquals(other.mostPopularAnimes, mostPopularAnimes)
      && listEquals(other.websiteInfos, websiteInfos);
  }

  @override
  int get hashCode => newEpisodes.hashCode
    ^ seasonalAnimes.hashCode
    ^ mostPopularAnimes.hashCode
    ^ websiteInfos.hashCode;
}
