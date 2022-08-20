
import 'package:nekosama/src/enums/ns_genres.dart';
import 'package:nekosama/src/enums/ns_sources.dart';
import 'package:nekosama/src/enums/ns_statuses.dart';
import 'package:nekosama/src/enums/ns_types.dart';
import 'package:nekosama/src/models/ns_anime_base.dart';
import 'package:nekosama/src/models/ns_titles.dart';


abstract class NSAnimeExtendedBase extends NSAnimeBase {

  final NSTitles titles;
  final List<NSGenres> genres;
  final NSSources source;
  final NSStatuses status;
  final NSTypes type;
  final double score;

  NSAnimeExtendedBase({
    required super.id,
    required super.title,
    required super.url,
    required super.thumbnail,
    required super.episodeCount,
    required this.titles,
    required this.genres,
    required this.source,
    required this.status,
    required this.type,
    required this.score,
  });
}
